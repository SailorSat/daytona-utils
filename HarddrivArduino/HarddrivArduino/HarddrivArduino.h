#ifndef DAYTONA_H
#define DAYTONA_H
  #include <stdint.h>
  #include <Arduino.h>

  typedef struct dataForController_t
  {
    int16_t x_axis : 16;
    int16_t y_axis : 16;
    int16_t z_axis : 16;
    int16_t rx_axis : 16;
    int16_t ry_axis : 16;
    int16_t rz_axis : 16;
    int16_t s0_axis : 16;
    int16_t s1_axis : 16;
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
    uint8_t button17 : 1;
    uint8_t button18 : 1;
    uint8_t button19 : 1;
    uint8_t button20 : 1;
    uint8_t button21 : 1;
    uint8_t button22 : 1;
    uint8_t button23 : 1;
    uint8_t button24 : 1;
  } dataForController_t;
#endif
