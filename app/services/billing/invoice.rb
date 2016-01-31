class Billing::Invoice
	def self.add_charge(id, attributes = {})
		result = ChargeBee::Invoice.add_charge(id, {
				:amount => attributes[:amount], 
			  :description => "#{ActionController::Base.helpers.pluralize(attributes[:count], attributes[:unit])}"
		})
	end
	def self.collect(id)
		ChargeBee::Invoice.collect(id)
	end

	def self.list_invoices(id)
		 result = ChargeBee::Invoice.invoices_for_customer(id, {
		  :limit => 100
		})
	end

	def self.pdf(id)
		result = ChargeBee::Invoice.pdf(id)
	end
end