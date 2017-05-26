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

  def new
  end

  def show
  end

  def create
    plan_id = 'monthly-membership'
    @amount = 1000
    customer = {
        phone: current_user.phone,
        email: current_user.email
    }

    ChargeBee::Subscription.create({
      plan_id: plan_id,
      customer: customer,
      card: {tmp_token: params[:stripeToken]}
    })

    respond_to do |format|
        format.html { redirect_to :show, notice: 'Thanks, you are now an active member!'}
        format.json { render :show, status: :created }
    end



  #   customer = Stripe::Customer.create(
  #       email: params[:stripeEmail],
  #       source: params[:stripeToken]
  #   )
  #
  #   Stripe::Charge.create(
  #       customer: customer.id,
  #       amount: @amount,
  #       description: 'BYP100 monthly dues',
  #       currency: 'usd'
  #   )
  # rescue Stripe::CardError => e
  #   redirect_to new_subscription_path, error: e.message
  end
end
