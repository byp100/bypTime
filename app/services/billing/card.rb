class Billing::Card
	def self.find(id)
		result = ChargeBee::Card.retrieve(id)
		result.card
	end

	def self.update_card_for_customer(customer_id, tmp_token)
		result = ChargeBee::Card.update_card_for_customer(customer_id, {
		  tmp_token: tmp_token
		})
	end
end