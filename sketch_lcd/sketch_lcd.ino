#include <Time.h>
#include <TinkerKit.h>
#include <LiquidCrystal.h>
#include <Wire.h>
#include <matrix_lcd_commands.h>
#include <TKLCD.h>

int lastMinute = -1;
char outputChar = 'A';
unsigned long lastPress = 0;
const unsigned long timeOut = 5000;
int printState = 1;

TKLCD_Local lcd = TKLCD_Local();
TKButton button(A0); 

void setup() {
  setTime(15,0,0,21,9,2013);
  lcd.begin();
  Serial1.begin(9600);
  Serial1.println("Doorbell ready"); 
}

void loop() {
  
  // calculate SMS authentication code
  if (minute() != lastMinute) {
    lcd.clear();
    // Calculate letter code
    outputChar = minute() % 26 + 65;
    lastMinute = minute();
  }
  
  unsigned long millisLastPress = millis() - lastPress;
  
  if (lastPress > 0 && (millisLastPress < timeOut)) {
    // turn on display
    lcd.display();
    lcd.setBrightness(255);
    if (millisLastPress < 2000) {
      if (printState == 1) {
        printState++;
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Press again to");
        lcd.setCursor(0,1);
        lcd.print("ring or text");
      } 
    }
    if (millisLastPress >=2000 && millisLastPress < 5000) {
      if (printState == 2) {
        printState++;
        lcd.clear();
        String msg = "Or txt '";
        msg.concat(outputChar);
        msg.concat("' & msg");
        lcd.setCursor(0,0);
        lcd.print(msg);
        lcd.setCursor(0,1);
        lcd.print("to xxx-xxx-xxxx");
      }
    }
  } else {
    lcd.noDisplay();
    lcd.setBrightness(0);
    printState = 1;
  }
  // Doorbell pressed, send to Raspberry PI
  // set lastPush to millis()
  // then have different loop conditions while less than 5sec have passed since last push
  // turn on display if less than five seconds
  // send to serial port message to ring if second press
  // have different text during intervals of the five seconds
  if (button.pressed() == HIGH) {
    if ((millisLastPress) > timeOut || lastPress == 0) {
      // send the passcode to server
      lastPress = millis();
      String ringStr = String(lastPress);
      ringStr.concat(" ");
      ringStr.concat(outputChar);
      Serial1.println(ringStr);
    } else {
      // upon a second press within 5 seconds,
      Serial1.println("ring");
    }
  }
}




