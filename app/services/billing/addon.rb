class Billing::Addon

	def self.find(id)
		result = ChargeBee::Addon.retrieve(id)
		result.addon
	end

	def self.all
		result = ChargeBee::Addon.list
		result.map{|entry| entry.addon}
	end

end