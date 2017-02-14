/*
HarddrivArduino v3
  v1 - initial relase

based on DaytonaUSB

A0  = X-Axis (Shift-X)
A1  = Y-Axis (Shift-Y)
A2  = Z-Axis (Wheel)
A3  = RX-Axis (Accel)
A4  = RY-Axis (Brake)
A5  = RZ-Axis (Clutch)
A6  = Slider0-Axis (Seat)
A7  = Slider1-Axis (unused (for now))

D21 = Button 1
D20 = Button 2
D19 = Button 3
D18 = Button 4
D17 = Button 5
D16 = Button 6
D15 = Button 7
D14 = Button 8

D0  = -        = -
D1  = -        = -
D2  = Wheel-PWM
D3  = Wheel-Direction
D4  = -
D5  = -
D6  = -
D7  = -
*/
#include "HarddrivArduino.h"

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
        // 1 - drive board command (not used on this one)
        break;
      case 0x02:
        // 2 - lamp data
        PORTK = val;
        break;
      case 0x03:
        // 3 - pwm timer command
        bool ccw = val & 0x80;
        byte frc = val & 0x7F;
        analogWrite(2, frc);
        digitalWrite(3, ccw);
        break;
    }
  }
}

void setupPins(void) {
  // set digital pins 2-3 as outputs
  for (int i = 2; i <= 3; i++) {
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }

  // set digital pins 4-21 as inputs with the pull-up enabled
  for (int i = 4; i <= 21; i++) {
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
  controllerData.button02 = !digitalRead(20);
  controllerData.button03 = !digitalRead(19);
  controllerData.button04 = !digitalRead(18);
  controllerData.button05 = !digitalRead(17);
  controllerData.button06 = !digitalRead(16);
  controllerData.button07 = !digitalRead(15);
  controllerData.button08 = !digitalRead(14);

  // unused buttons
  controllerData.button09 = 0;
  controllerData.button10 = 0;
  controllerData.button11 = 0;
  controllerData.button12 = 0;
  controllerData.button16 = 0;
  controllerData.button17 = 0;
  controllerData.button18 = 0;
  controllerData.button19 = 0;
  controllerData.button20 = 0;
  controllerData.button21 = 0;
  controllerData.button22 = 0;
  controllerData.button23 = 0;
  controllerData.button24 = 0;
 
  // get the analog data
  controllerData.s1_axis = analogRead(A7);
  controllerData.s0_axis = analogRead(A6);
  controllerData.rz_axis = analogRead(A5);
  controllerData.ry_axis = analogRead(A4);
  controllerData.rx_axis = analogRead(A3);
  controllerData.z_axis = analogRead(A2);
  controllerData.y_axis = analogRead(A1);
  controllerData.x_axis = analogRead(A0);
}
