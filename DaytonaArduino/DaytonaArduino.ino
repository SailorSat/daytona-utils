/*
DaytonaArduino v3
  v3 - added additional buttons
       added flight-stick mode

  v2 - support for DayontaUSB

  v1 - initial relase

based on BigPanik Model2Pac v1.2 Final
Interface Model 1/2/2A/2B/2C/3 hardware (wheel, pedals, buttons, gear, FFB and lamps) to USB

A0  = X-Axis (WHEEL)
A1  = Y-Axis (ACCEL)
A2  = Z-Axis (BRAKE)

D21 = 24BIT-01 = Button 1
D20 = 24BIT-03 = Button 3
D19 = 24BIT-04 = Button 4
D18 = 24BIT-05 = Button 5
D17 = 24BIT-06 = Button 6
D16 = 24BIT-07 = Button 7
D15 = 24BIT-08 = Button 8
D14 = 24BIT-09 = Button 9

D0  = -        = -
D1  = -        = -
D2  = 24BIT-10 = Button 10
D3  = 24BIT-11 = Button 11
D4  = 24BIT-12 = Button 12
D5  = 24BIT-13 = Button 13 (SHIFT0)
D6  = 24BIT-14 = Button 14 (SHIFT1)
D7  = 24BIT-15 = Button 15 (SHIFT2)

D8  = 24BIT-16 = Button 16
D9  = 24BIT-02 = Button 2

D10 = OPTION0  = DECODER
D11 = OPTION1  = MODE (RACE/ FLIGHT)
D12 = OPTION2  = N/C

SHIFT-DECODER
-------------
GEAR N         = Button 20
GEAR 1         = Button 21
GEAR 2         = Button 22
GEAR 3         = Button 23
GEAR 4         = Button 24
*/
#include "DaytonaArduino.h"

dataForController_t controllerData;
byte size = sizeof(dataForController_t) - 1;

void setup() {
  setupPins();
  setupSerial();
  getControllerData();
}

void loop() {
  while (Serial.available() > 1) {
    byte cmd = Serial.read();
    byte val = Serial.read();
    switch (cmd) {
      case 0x00:
        // 0 - controller feed
        if (val == 0) {
          getControllerData();
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

void getControllerData(void) {
  // digital pin 21-14
  controllerData.button01 = !digitalRead(21);
  controllerData.button03 = !digitalRead(20);
  controllerData.button04 = !digitalRead(19);
  controllerData.button05 = !digitalRead(18);
  controllerData.button06 = !digitalRead(17);
  controllerData.button07 = !digitalRead(16);
  controllerData.button08 = !digitalRead(15);
  controllerData.button09 = !digitalRead(14);

  // digital pin 2-7
  controllerData.button10 = !digitalRead(2);
  controllerData.button11 = !digitalRead(3);
  controllerData.button12 = !digitalRead(4);
  controllerData.button16 = !digitalRead(8);

  // digital pin 8-9
  controllerData.button16 = !digitalRead(8);
  controllerData.button02 = !digitalRead(9);

  // unused buttons
  controllerData.button17 = 0;
  controllerData.button18 = 0;
  controllerData.button19 = 0;

  // OPTION0 - DECODE
  if (!digitalRead(10)) {
    // decoder disabled
    controllerData.button13 = !digitalRead(5);
    controllerData.button14 = !digitalRead(6);
    controllerData.button15 = !digitalRead(7);
    controllerData.button20 = 0;
    controllerData.button21 = 0;
    controllerData.button22 = 0;
    controllerData.button23 = 0;
    controllerData.button24 = 0;
  } else {
    // decoder active
    controllerData.button13 = 0;
    controllerData.button14 = 0;
    controllerData.button15 = 0;
    // Gear
    // 4=1+2/!3+4 = 4
    // 3=2/4      = 2
    // 2=1/3      = 1
    switch (!digitalRead(5) + !digitalRead(6) * 2 + !digitalRead(7) * 4) {
      case 0x05:
        // gear 1
        controllerData.button20 = 0;
        controllerData.button21 = 1;
        controllerData.button22 = 0;
        controllerData.button23 = 0;
        controllerData.button24 = 0;
        break;

      case 0x06:
        // gear 2
        controllerData.button20 = 0;
        controllerData.button21 = 0;
        controllerData.button22 = 1;
        controllerData.button23 = 0;
        controllerData.button24 = 0;
        break;

      case 1:
        // gear 3
        controllerData.button20 = 0;
        controllerData.button21 = 0;
        controllerData.button22 = 0;
        controllerData.button23 = 1;
        controllerData.button24 = 0;
        break;

      case 2:
        // gear 4
        controllerData.button20 = 0;
        controllerData.button21 = 0;
        controllerData.button22 = 0;
        controllerData.button23 = 0;
        controllerData.button24 = 1;
        break;

      default:
        // neutral
        controllerData.button20 = 1;
        controllerData.button21 = 0;
        controllerData.button22 = 0;
        controllerData.button23 = 0;
        controllerData.button24 = 0;
    }
  }
 
  // get the analog data
  analogRead(A8);
  // OPTION1 - mode selection
  if (!digitalRead(11)) {
    // flight stick mode
    controllerData.rz_axis = 0x0200;
    controllerData.z_axis = analogRead(A2);
    controllerData.y_axis = analogRead(A1);
    controllerData.x_axis = analogRead(A0);
  } else {
    // racing mode
    controllerData.rz_axis = analogRead(A2);
    controllerData.z_axis = analogRead(A1);
    controllerData.y_axis = 0x0200;
    controllerData.x_axis = analogRead(A0);
  }
}
