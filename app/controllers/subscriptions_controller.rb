require 'error_handler'

class SubscriptionsController < ApplicationController
  rescue_from ChargeBee::PaymentError do |ex|
    if "card[number]" == ex.param
      redirect_to :back, notice: "Please recheck your card number."
    else
      redirect_to :back, notice: "Your payment method was declined. Please try another card."
    end
  end

  rescue_from ChargeBee::InvalidRequestError do |ex|
    redirect_to :back, notice: ex.param
  end

  rescue_from ChargeBee::APIError do |ex|
    render json: {ex: ex}, status: :unprocessable_entity
  end

  def show
    @subscription = ChargeBee::Subscription.retrieve(current_user.customer_id).subscription if current_user.customer_id.present?
  end

  def create
    plan_id = 'membership_monthly'
    @amount = 1000
    customer = {
        first_name: current_user.name.split(' ').first,
        last_name: current_user.name.split(' ').second,
        phone: current_user.phone,
        email: current_user.email
    }

    subscription = create_subscription plan_id, customer
    current_user.update(customer_id: subscription.customer.id)
    current_user.aasm_state == 'prospective' ? current_user.induct! : current_user.activate!

    flash[:notice] = 'Thanks, you are now an active member!'
    respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: current_user, status: :created }
    end
  end

  def destroy
    if current_user.customer_id.present?
      ChargeBee::Subscription.cancel(current_user.customer_id)
      current_user.deactivate!
      flash[:notice] = 'You have successfully canceled your membership'
    else
      flash[:error] = 'You do not have a currently active membership'
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render json: current_user, status: :ok}
    end
  end

  private

  def create_subscription plan_id, customer
    ChargeBee::Subscription.create({
      plan_id: plan_id,
      customer: customer,
      card: {tmp_token: params[:stripeToken]}
    })
  end
end
