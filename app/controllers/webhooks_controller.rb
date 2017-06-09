class WebhooksController < ApplicationController
  protect_from_forgery with: :null_session
  http_basic_authenticate_with name: ENV['webhooks_name'], password: ENV['webhooks_password']

  rescue_from ChargeBee::PaymentError do |ex|
    render json: {ex: ex}, status: :unprocessable_entity
  end

  rescue_from ChargeBee::InvalidRequestError do |ex|
    render json: {ex: ex}, status: :unprocessable_entity
  end

  rescue_from ChargeBee::APIError do |ex|
    render json: {ex: ex}, status: :unprocessable_entity
  end

  def chargebee_event
    puts "Processing #{params[:event_type]} event"

    if params[:event_type] == 'invoice_created'
      invoice = params[:content][:invoice]
      customer = User.find_by(customer_id: invoice[:customer_id])

      unless customer.nil? or customer.manual_invoicing or invoice[:status] == 'paid'
        result = ChargeBee::Invoice.collect_payment(invoice[:id])
        render json: {outcome: 'Event Processed.', result: result}
      end
    else
      render json: {outcome: 'Not processed.'}
    end
  end

end
