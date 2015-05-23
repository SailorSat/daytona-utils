/*
DaytonaArduino v1

based on BigPanik Model2Pac v1.2 Final
Interface Model 2 hardware (wheel, pedals, buttons, gear, FFB and lamps) to USB

WHEEL   = A0  = X-Axis
ACCELL  = A1  = Y-Axis
BRAKE   = A2  = Z-Axis

VR4     = D14 = Button 4
VR3     = D15 = Button 3
VR2     = D16 = Button 2
VR1     = D17 = Button 1
START   = D18 = Button 5
SERVICE = D19 = Button 6
TEST    = D20 = Button 7
COIN    = D21 = Button 8

GEAR A  = D7  = Button 9
GEAR B  = D6  = Button 10
GEAR C  = D5  = Button 11
DECODE  = D4
          *** = Button 12, Button 13, Button 14, Button 15, Button 16
*/
#include "DaytonaArduino.h"

byte DrivValue = 0;
byte LampValue = 0;
byte FlipFlop = 2;
unsigned long lastTick = 0;

void setup() {
  setupPins();
  setupSerial();
}

void loop() {
  if (millis() - lastTick >= 16) {
    lastTick = millis();
    dataForController_t controllerData = getControllerData();
    Serial.write(0xA5);
    for (byte offset = 0; offset < 8; offset++) {
      Serial.write(((uint8_t*)&controllerData)[offset]);
    }
  }

  while (Serial.available() > 0) {
    // Always be setting fresh Output (FFB + Lamps) data
    byte readData = Serial.read();
    if (readData == 0xA5 && FlipFlop > 1 ) {
      // sync byte
      FlipFlop = 0;
    } else {
      if (FlipFlop == 0) {
        // drive board data
        if (DrivValue != readData) {
          DrivValue = readData;
          PORTA = DrivValue;
        }
      } else if (FlipFlop == 1) {
        // lamp data
        if (LampValue != readData) {
          LampValue = readData;
          PORTK = LampValue;
        }
      }
      FlipFlop++;
    }
  }
}

void setupPins(void) {
  // set digital pins 2-21 as inputs with the pull-up enabled
  for (int i = 2; i <= 21; i++) {
    pinMode(i, INPUT);
    digitalWrite(i, HIGH);
  }

  // drive board connected on port A (digital pins 22-29)
  DDRA = 0xFF;
  PORTA = 0x00;

  // lamps connected on port K (analog pins 08-15)
  DDRK = 0xFF;
  PORTK = 0x00;
}

void setupSerial() {
  // Start the serial port
  Serial.begin(115200);
  Serial.write(0xA5);
}

dataForController_t getControllerData(void) {
  // prepare data
  dataForController_t controllerData;

  // get the analog data
  analogRead(A4);
  controllerData.axis3 = analogRead(A2);
  controllerData.axis2 = analogRead(A1);
  controllerData.axis1 = analogRead(A0);

  // VR
  controllerData.button01 = !digitalRead(17);
  controllerData.button02 = !digitalRead(16);
  controllerData.button03 = !digitalRead(15);
  controllerData.button04 = !digitalRead(14);

  // Start, Service, Test, Coin
  controllerData.button05 = !digitalRead(18);
  controllerData.button06 = !digitalRead(19);
  controllerData.button07 = !digitalRead(20);
  controllerData.button08 = !digitalRead(21);

  // DECODE
  if (!digitalRead(4)) {
    controllerData.button09 = !digitalRead(7);
    controllerData.button10 = !digitalRead(6);
    controllerData.button11 = !digitalRead(5);
    controllerData.button12 = 0;
    controllerData.button13 = 0;
    controllerData.button14 = 0;
    controllerData.button15 = 0;
    controllerData.button16 = 0;
  } else {
    controllerData.button09 = 0;
    controllerData.button10 = 0;
    controllerData.button11 = 0;
    // Gear
    // 4=1+2/!3+4 = 4
    // 3=2/4      = 2
    // 2=1/3      = 1
    switch (!digitalRead(5) + !digitalRead(6) * 2 + !digitalRead(7) * 4) {
      case 5:
        // gear 1
        controllerData.button12 = 1;
        controllerData.button13 = 0;
        controllerData.button14 = 0;
        controllerData.button15 = 0;
        controllerData.button16 = 0;
        break;

      case 6:
        // gear 2
        controllerData.button12 = 0;
        controllerData.button13 = 1;
        controllerData.button14 = 0;
        controllerData.button15 = 0;
        controllerData.button16 = 0;
        break;

      case 1:
        // gear 3
        controllerData.button12 = 0;
        controllerData.button13 = 0;
        controllerData.button14 = 1;
        controllerData.button15 = 0;
        controllerData.button16 = 0;
        break;

      case 2:
        // gear 4
        controllerData.button12 = 0;
        controllerData.button13 = 0;
        controllerData.button14 = 0;
        controllerData.button15 = 1;
        controllerData.button16 = 0;
        break;

      default:
        // neutral
        controllerData.button12 = 0;
        controllerData.button13 = 0;
        controllerData.button14 = 0;
        controllerData.button15 = 0;
        controllerData.button16 = 1;
    }
  }

  // And return the data!
  return controllerData;
}
