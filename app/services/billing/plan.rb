class Billing::Plan

	def self.find(id)
		result = ChargeBee::Plan.retrieve(id)
		result.plan
	end

	def self.all
		result = ChargeBee::Plan.list(:limit => 100)
		result.map{|entry| entry.plan}
	end

end