require 'twilio-ruby'
class TwilioService
	def initialize
		@client = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
	end


 	def send(message, number)
		@message = @client.messages.create(
	  	to: "+1#{number}",
	  	from: ENV['twilio_number'],
	  	body: message
		)
	end

	# def reply(message)
	# 	twiml = Twilio::TwiML::Response.new do |r|
	# 	  r.Message message
	# 	end
	# 	twiml
	# end
end