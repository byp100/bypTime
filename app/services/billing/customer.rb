class Billing::Customer
	def self.update(id, customer)
		result = ChargeBee::Customer.update(id, customer)
		result = ChargeBee::Customer.update_billing_info(id, {
		  billing_address: customer[:billing_address]
		})
	end
	def self.find_by_subscription(subscription_id)
		result = ChargeBee::Subscription.retrieve(subscription_id)
		customer = result.customer
	end
end