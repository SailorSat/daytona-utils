#ifndef DAYTONA_H
#define DAYTONA_H
  #include <stdint.h>
  #include <Arduino.h>

  typedef struct dataForController_t
  {
    int16_t axis1 : 16;
    int16_t axis2 : 16;
    int16_t axis3 : 16;
    uint8_t button01 : 1;
    uint8_t button02 : 1;
    uint8_t button03 : 1;
    uint8_t button04 : 1;
    uint8_t button05 : 1;
    uint8_t button06 : 1;
    uint8_t button07 : 1;
    uint8_t button08 : 1;
    uint8_t button09 : 1;
    uint8_t button10 : 1;
    uint8_t button11 : 1;
    uint8_t button12 : 1;
    uint8_t button13 : 1;
    uint8_t button14 : 1;
    uint8_t button15 : 1;
    uint8_t button16 : 1;
  } dataForController_t;
#endif
