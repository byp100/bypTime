class Billing::Subscription
	def self.find(id)
		result = ChargeBee::Subscription.retrieve(id)
		result.plan
	end

	def self.reactivate(id)
		result = ChargeBee::Subscription.reactivate(id)
	end

	def self.update(id, attributes = {})
		result = ChargeBee::Subscription.update(id, attributes)
	end

	def self.cancel(id, end_of_term)
		result = ChargeBee::Subscription.cancel(id, {end_of_term: end_of_term})
	end

	def self.create(attributes, customer)
		result = ChargeBee::Subscription.create({
		  :plan_id => attributes[:plan_id],
		  :customer => customer,
		  :card => {
		    :tmp_token => attributes[:stripeToken]
		  }
		})
		result.subscription
	end
end