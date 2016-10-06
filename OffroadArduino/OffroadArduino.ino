#include "OffroadArduino.h"

dataForController_t controllerData;

volatile int encoder0Pos = 0;
volatile int encoder1Pos = 0;
volatile int encoder2Pos = 0;

void setup() {
  setupPins();
  setupSerial();
  setupControllerData();
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
      case 0x30:
        // 0x30 - debug feed
        getControllerData();
        for (int i = 0; i <= 31; i++){
          Serial.print(((uint8_t*)&controllerData)[i], HEX);
          Serial.print(", ");
        }
        Serial.println("");
        break;
    }
  }
}

void setupPins() {
  // set digital pins 22-37 as inputs with the pull-up enabled
  for (int i = 22; i <= 37; i++) {
    pinMode(i, INPUT);
    digitalWrite(i, HIGH);
  }
 
  // set encoder pins as inputs without pull-ups
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  digitalWrite(2, LOW);
  digitalWrite(3, LOW);
  
  pinMode(21, INPUT);
  pinMode(20, INPUT);
  digitalWrite(21, LOW);
  digitalWrite(20, LOW);
  
  pinMode(19, INPUT);
  pinMode(18, INPUT);
  digitalWrite(19, LOW);
  digitalWrite(18, LOW);

  // start encoder pin interrupts
  attachInterrupt(digitalPinToInterrupt(2), doEncoder0A, CHANGE);
  attachInterrupt(digitalPinToInterrupt(3), doEncoder0B, CHANGE);
  attachInterrupt(digitalPinToInterrupt(21), doEncoder1A, CHANGE);
  attachInterrupt(digitalPinToInterrupt(20), doEncoder1B, CHANGE);
  attachInterrupt(digitalPinToInterrupt(19), doEncoder2A, CHANGE);
  attachInterrupt(digitalPinToInterrupt(18), doEncoder2B, CHANGE);
}

void setupSerial() {
  // Start the serial port
  Serial.begin(250000);
  Serial.write(0xA5);
}

void setupControllerData() {
  // set report ids
  controllerData.report0 = 1;
  controllerData.report1 = 2;
  controllerData.report2 = 3;
  controllerData.report3 = 4;
  
  // clear padding bytes
  controllerData.padding0 = 0;
  controllerData.padding1 = 0;
  controllerData.padding2 = 0;
  
  // read initial values
  getControllerData();
}

void getControllerData() {
  // read button port
  byte a = PINA;
  byte c = PINC;
  
  // nitro buttons
  controllerData.button01 = !bitRead(a, 1);
  controllerData.button11 = !bitRead(a, 3);
  controllerData.button21 = !bitRead(a, 5);
  controllerData.button31 = !bitRead(c, 1);
  controllerData.button32 = !bitRead(c, 3);
  controllerData.button33 = !bitRead(c, 5);
  
  // service button
  controllerData.button03 = !bitRead(a, 6);
  controllerData.button34 = !bitRead(c, 6);

  // coin buttons
  controllerData.button02 = !bitRead(a, 0);
  controllerData.button12 = !bitRead(a, 2);
  controllerData.button22 = !bitRead(a, 4);
  controllerData.button35 = !bitRead(c, 0);
  controllerData.button36 = !bitRead(c, 2);
  controllerData.button37 = !bitRead(c, 4);
  
  // unused button
  controllerData.button23 = 0;
  controllerData.button33 = 0;
  controllerData.button38 = 0;
  
  // analog pedals
  analogRead(A8);
  controllerData.rz_axis = analogRead(A2);
  controllerData.ry_axis = analogRead(A1);
  controllerData.rx_axis = analogRead(A0);
  
  // quad encoders
  controllerData.x0_axis = encoder0Pos;
  encoder0Pos = 0;

  controllerData.x1_axis = encoder1Pos;
  encoder1Pos = 0;

  controllerData.x2_axis = encoder2Pos;
  encoder2Pos = 0;
}

int doEncoderIntA(byte a, byte b) {
  // look for a low-to-high on channel A
  if (a == HIGH) {
    // check channel B to see which way encoder is turning
    if (b == LOW) {
      return 1;          // CW
    } else {
      return -1;         // CCW
    }
  }
  else   // must be a high-to-low edge on channel A
  {
    // check channel B to see which way encoder is turning
    if (b == HIGH) {
      return 1;          // CW
    } else {
      return - 1;        // CCW
    }
  }
}

int doEncoderIntB(byte a, byte b) {
  // look for a low-to-high on channel B
  if (b == HIGH) {
    // check channel A to see which way encoder is turning
    if (a == HIGH) {
      return 1;          // CW
    } else {
      return -1;         // CCW
    }
  }
  else   // must be a high-to-low edge on channel B
  {
    // check channel A to see which way encoder is turning
    if (a == LOW) {
      return 1;          // CW
    } else {
      return - 1;        // CCW
    }
  }
}

void doEncoder0A() {
  // PE4, PE5
  byte port = PINE;
  byte a = bitRead(port, 4);
  byte b = bitRead(port, 5);
  encoder0Pos += doEncoderIntA(a, b);
}

void doEncoder0B() {
  // PE4, PE5
  byte port = PINE;
  byte a = bitRead(port, 4);
  byte b = bitRead(port, 5);
  encoder0Pos += doEncoderIntB(a, b);
}

void doEncoder1A() {
  // PD0, PD1
  byte port = PIND;
  byte a = bitRead(port, 0);
  byte b = bitRead(port, 1);
  encoder1Pos += doEncoderIntA(a, b);
}

void doEncoder1B() {
  // PD0, PD1
  byte port = PIND;
  byte a = bitRead(port, 0);
  byte b = bitRead(port, 1);
  encoder1Pos += doEncoderIntB(a, b);
}

void doEncoder2A() {
  // PD2, PD3
  byte port = PIND;
  byte a = bitRead(port, 2);
  byte b = bitRead(port, 3);
  encoder2Pos += doEncoderIntA(a, b);
}

void doEncoder2B() {
  // PD2, PD3
  byte port = PIND;
  byte a = bitRead(port, 2);
  byte b = bitRead(port, 3);
  encoder2Pos += doEncoderIntB(a, b);
}
