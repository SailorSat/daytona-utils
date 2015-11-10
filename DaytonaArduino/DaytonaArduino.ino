/*
DaytonaArduino v2
  v2 - support for DayontaUSB
  v1 - initial relase

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

dataForController_t controllerData = getControllerData();
byte size = sizeof(dataForController_t) - 1;

void setup() {
  setupPins();
  setupSerial();
}

void loop() {
  while (Serial.available() > 1) {
    byte cmd = Serial.read();
    byte val = Serial.read();
    switch (cmd) {
      case 0x00:
        // 0 - controller feed
        if (val == 0) {
          controllerData = getControllerData();
        }
        Serial.write(((uint8_t*)&controllerData)[val]);
        break;
      case 0x01:
        // 1 - drive board command
        PORTA = val;
        break;
      case 0x02:
        // 2 - lamp data
        PORTK = val;
        break;
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
  Serial.begin(250000);
  Serial.write(0xA5);
}

dataForController_t getControllerData(void) {
  // prepare data
  dataForController_t controllerData;

  // get the analog data
  analogRead(A8);
  controllerData.rz_axis = analogRead(A2);
  controllerData.z_axis = analogRead(A1);
  controllerData.x_axis = analogRead(A0);

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
  controllerData.rx = 0;
  
  // And return the data!
  return controllerData;
}
