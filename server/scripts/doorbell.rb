#!/usr/bin/env ruby

require 'rubygems'
require 'twilio-ruby'
 
# Get your Account Sid and Auth Token from twilio.com/user/account
account_sid = 'ACe77e1c782cfb079f2436c385e18ff702'
auth_token = '83dc2f126b4d038d4902bdcb1b671574'
@client = Twilio::REST::Client.new account_sid, auth_token
 
#message = @client.account.sms.messages.create(:body => "This is Gerardo",
#    :to => "+14155773484",     # Replace with your phone number
#    :from => "+14088004885")   # Replace with your Twilio number
#puts message.sid

# Loop over messages and print out a property for each one
#@client.account.sms.messages.list(:to => '+14088004885').each do |message|
#    puts "#{message.to} #{message.from} #{message.body}"
#end

# need to add filtering for code
# need to add to make sure only msgs from the last time cron ran came in

doorbellMsg = "Incomming visitor message, "
doorbellMsg += @client.account.sms.messages.list(:to => '+14088004885').first.body

puts @client.account.sms.messages.list(:to => '+14088004885').first.date_sent
begin
  file = File.open("/home/pi/visitormsg.txt", "w")
  file.write(doorbellMsg)
rescue IOError => e
  puts "file writing error"
ensure
  file.close unless file == nil
end
