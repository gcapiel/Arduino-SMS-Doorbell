#include <Time.h>
#include <TinkerKit.h>
#include <LiquidCrystal.h>
#include <Wire.h>
#include <matrix_lcd_commands.h>
#include <TKLCD.h>

int lastMinute = -1;
char outputChar = 'A';

TKLCD_Local lcd = TKLCD_Local();
TKButton button(A0); 

void setup() {
  setTime(15,0,0,21,9,2013);
  lcd.begin();
  Serial1.begin(9600);
  Serial1.println("Doorbell ready"); 
}

void loop() {
  
  if (minute() != lastMinute) {
    lcd.clear();
    // Calculate letter code
    outputChar = minute() % 26 + 65;
    String msg = "To ring txt '";
    msg.concat(outputChar);
    msg.concat("'");
    lcd.setCursor(0,0);
    lcd.print(msg);
    lcd.setCursor(0,1);
    lcd.print("to XXX-XXX-XXXX");
    lastMinute = minute();
  }
  // Turn on display
  if (button.read() == HIGH) {
    lcd.display();
    lcd.setBrightness(255);
  } else {
    lcd.noDisplay();
    lcd.setBrightness(0);
  }
  // Doorbell pressed, send to Raspberry PI
  if (button.pressed() == HIGH) {
    String ringStr = String(millis());
    ringStr.concat(" ");
    ringStr.concat(outputChar);
    Serial1.println(ringStr);
  }
}




