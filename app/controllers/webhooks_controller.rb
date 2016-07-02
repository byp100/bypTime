class WebhooksController < ApplicationController
	protect_from_forgery with: :null_session
	http_basic_authenticate_with name: ENV['webhooks_name'], password: ENV['webhooks_password']

	def chargebee_event
		if params[:event_type] == "subscription_cancelled"

		elsif params[:event_type] == "invoice_created"

			invoice = params[:content][:invoice]
			
			customer = User.find_by(customer_id: params[:content][:customer][:id])

				unless customer.manual_invoicing == true
					Billing::Invoice.collect(invoice[:id])
				end
				render json: {outcome: "Event Processed."}

		else
			render json: {outcome: "Not processed."}
		end
	end

end
