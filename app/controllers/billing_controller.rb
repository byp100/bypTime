class BillingController < ApplicationController
  rescue_from ChargeBee::PaymentError do |ex|
      # First check for card parameters entered by the user.
      # We recommend you to validate the input at the client side itself to catch simple mistakes.
      if "card[number]" == ex.param
        # Ask your user to recheck the card number. A better way is to use
        # Stripe's https://github.com/stripe/jquery.payment for validating it in the client side itself.

      #elsif <other card params> == ex.param
        # Similarly check for other card parameters entered by the user.
        # ....

      else
        redirect_to :back, notice: "Your payment method was declined. Please try another card."
      end
  end  
  rescue_from ChargeBee::InvalidRequestError do |ex|
    redirect_to :back, notice: ex.param
  end
  def edit
  	if current_user.subscribed?
     result = ChargeBee::Subscription.retrieve(current_user.customer_id)
      @customer = result.customer
      result = ChargeBee::Card.retrieve(current_user.customer_id)
      card = result.card
      @card_summary = "Card Details: #{card.card_type.titleize} ending in #{card.last4}"
    else
    	redirect_to billing_enroll_path
    end
  end

  def update_card
    result = ChargeBee::Card.update_card_for_customer(current_user.customer_id, {
      tmp_token: params[:stripeToken]
    })
    render json: {success: true}
  end

  def update_contact
    result = ChargeBee::Customer.update(current_user.customer_id, params[:customer])
    result = ChargeBee::Customer.update_billing_info(current_user.customer_id, {
      billing_address: params[:customer][:billing_address]
    })
    redirect_to dashboard, notice: "The billing contact info has been updated."
  end

  def enroll
  	if current_user.subscribed?
  		redirect_to billing_edit_path
	  else
	  	plans = ChargeBee::Plan.list.select{|plan| plan.plan.status == "active"}
	  	@plans = []
	  	plans.each do |plan|
	  		@plans.push(plan.plan)
	  	end
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

       result = ChargeBee::Subscription.create({
         :plan_id => params[:subscription][:plan_id],
         :customer => customer,
         :card => {
           :tmp_token => params[:subscription][:stripeToken]
         }
       })
       current_user.customer_id = result.customer.id
       current_user.save
       current_user.induct!
   else
     redirect_to settings_billing_path, notice: "You are already paying dues."
   end
 end
end
