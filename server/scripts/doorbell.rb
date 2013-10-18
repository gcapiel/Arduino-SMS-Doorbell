#!/usr/bin/env ruby

require 'twilio-ruby'
require 'time'

#called from another ruby program by
#system("/home/pi/doorbell.rb > /dev/null &")

def announceSMS(sms_msg)

	doorbellMsg = "Incomming visitor message, "
	doorbellMsg += sms_msg

	begin
	  file = File.open("/home/pi/visitormsg.txt", "w")
	  file.write(doorbellMsg)
	rescue IOError => e
	  puts "file writing error"
	ensure
	  file.close unless file == nil
	end

	# create TTS mp3 file from visitormsg.txt and move to web root
	system("/home/pi/doorbell.sh")

	puts Net::HTTP.get(URI.parse("http://192.168.1.147/receiver_on.php"))
	sleep(10)
	puts Net::HTTP.get(URI.parse("http://192.168.1.147/sonosplay.php?file=visitormsg"))
	sleep(7)
	puts Net::HTTP.get(URI.parse("http://192.168.1.147/clear_queue.php"))
	puts Net::HTTP.get(URI.parse("http://192.168.1.147/receiver_off.php"))

end

# Get your Account Sid and Auth Token from twilio.com/user/account
account_sid = ''
auth_token = ''
sms_number = ''
@client = Twilio::REST::Client.new account_sid, auth_token
 
startTime = DateTime.now.to_time

# check every 5 seconds for 3000 seconds to see if any messages have come in
while ((DateTime.now.to_time - startTime) < 3000) do

	lastSMSTime = @client.account.sms.messages.list(:to => sms_number).first.date_sent
	
	if (DateTime.now.new_offset(0).to_time - DateTime.parse(lastSMSTime).to_time) < 3000
		announceSMS @client.account.sms.messages.list(:to => sms_number).first.body
		exit
	end
	
	sleep(5)
	
end