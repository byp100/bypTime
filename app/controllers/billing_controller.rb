class BillingController < ApplicationController
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

  def show
  end

  def edit
    if current_user.subscribed?
      @customer = ChargeBee::Subscription.retrieve(current_user.customer_id).customer
      card = ChargeBee::Card.retrieve(current_user.customer_id).card
      @card_summary = "Card Details: #{card.card_type.titleize} ending in #{card.last4}"
    else
      redirect_to billing_enroll_path
    end
  end

  def pending_invoices
    @pending_invoices = ChargeBee::Invoice.invoices_for_customer(current_user.customer_id).select {|result| result.invoice.status == "pending"}
  end

  def close_invoice
    ChargeBee::Invoice.collect(params[:invoice_id])
    redirect_to billing_pending_invoices_path, notice: "Thanks for paying your invoice!"
  end

  def update_card
    ChargeBee::Card.update_card_for_customer(current_user.customer_id, {
        tmp_token: params[:stripeToken]
    })
    render json: {success: true}
  end

  def update_contact
    ChargeBee::Customer.update(current_user.customer_id, params[:customer])
    ChargeBee::Customer.update_billing_info(current_user.customer_id, {
        billing_address: params[:customer][:billing_address]
    })
    redirect_to dashboard, notice: "The billing contact info has been updated."
  end

  def enroll
    if current_user.subscribed?
      redirect_to billing_edit_path
    else
      @plans = ChargeBee::Plan.list.select {|plan| plan.plan.status == "active"}.map {|plan| plan.plan}
    end

  end

  def overview
    if current_user.aasm_state == "active"
      redirect_to billing_edit_path
    else
      redirect_to billing_enroll_path
    end
  end

  def subscribe
    if current_user.aasm_state == "prospective"
      customer = params[:subscription][:customer]

      customer[:billing_address][:first_name] = customer[:first_name]
      customer[:billing_address][:last_name] = customer[:last_name]

      subscription = create_subscription(customer)
      current_user.update(customer_id: subscription.customer.id)
    else
      redirect_to settings_billing_path, notice: "You are already paying dues."
    end
  end

  def create_subscription(customer)
    ChargeBee::Subscription.create({plan_id: params[:subscription][:plan_id],
                                    customer: customer,
                                    card: {tmp_token: params[:subscription][:stripeToken]}
                                   })
  end
end
