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
}

void loop() {
  
  if (minute() != lastMinute) {
    lcd.clear();
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
  if (button.read() == HIGH) {
    lcd.display();
    lcd.setBrightness(255);
  } else {
    lcd.noDisplay();
    lcd.setBrightness(0);
  }
}




