#!/usr/bin/env ruby

#simplest ruby program to read from arduino serial, 
#using the SerialPort gem
#(http://rubygems.org/gems/serialport)

require "serialport"
require "net/http"

#params for serial port
port_str = "/dev/rfcomm0"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

#just read forever
while true do
   while (i = sp.gets.chomp) do
   
      puts i
      puts Net::HTTP.get(URI.parse("http://192.168.1.147/receiver_on.php"))
      sleep(3)
      puts Net::HTTP.get(URI.parse("http://192.168.1.147/sonosplay.php?file=you_rang"))
      sleep(7)
      puts Net::HTTP.get(URI.parse("http://192.168.1.147/receiver_off.php"))

      #system('say "holy guacamole someones at the door"')
    end
end
sp.close
