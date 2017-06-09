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

    case params[:event_type]
    when 'invoice_created'
      invoice = params[:content][:invoice]
      customer = User.find_by(customer_id: invoice[:customer_id])

      if customer.nil?
        result = 'Customer not found'
      elsif customer.manual_invoicing
        result = 'Manual invoicing enabled'
      elsif invoice[:status] == 'paid'
        result = 'Invoice is already paid'
      else
        result = ChargeBee::Invoice.collect_payment(invoice[:id])
      end

      render json: {outcome: 'Event Processed.', result: result}
    else
      render json: {outcome: 'Not processed.'}
    end
  end
end
