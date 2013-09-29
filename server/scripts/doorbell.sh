#!/bin/bash

PATH=$PATH:$HOME/.rvm/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

rm /home/pi/visitormsg.txt

/home/pi/doorbell.rb

if [ -e "/home/pi/visitormsg.txt" ]
then

	espeak -f /home/pi/visitormsg.txt --stdout > myaudio && ffmpeg -i myaudio -vn -ar 44100 -ac 2 -ab 192k -f mp3 /home/pi/visitormsg.mp3
	sudo mv /home/pi/visitormsg.mp3 /var/www/visitormsg.mp3

	# need to add turn on receiver and wait 10 seconds
	curl http://192.168.1.147/sonosplay.php?file=visitormsg
	# need to add a wait 10 seconds before turning off receiver

fi

