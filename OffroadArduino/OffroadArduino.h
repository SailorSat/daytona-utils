#ifndef DAYTONA_H
#define DAYTONA_H
  #include <stdint.h>
  #include <Arduino.h>

  typedef struct dataForController_t
  {
    uint8_t report0 : 8;
    uint8_t button01 : 1;
    uint8_t button02 : 1;
    uint8_t button03 : 1;
    uint8_t padding0 : 5;
    int16_t x0_axis : 16;
    int16_t y0_axis : 16;
    int16_t z0_axis : 16;
    
    uint8_t report1 : 8;
    uint8_t button11 : 1;
    uint8_t button12 : 1;
    uint8_t button13 : 1;
    uint8_t padding1 : 5;
    int16_t x1_axis : 16;
    int16_t y1_axis : 16;
    int16_t z1_axis : 16;
    
    uint8_t report2 : 8;
    uint8_t button21 : 1;
    uint8_t button22 : 1;
    uint8_t button23 : 1;
    uint8_t padding2 : 5;
    int16_t x2_axis : 16;
    int16_t y2_axis : 16;
    int16_t z2_axis : 16;
    
    uint8_t report3 : 8;
    uint8_t button31 : 1;
    uint8_t button32 : 1;
    uint8_t button33 : 1;
    uint8_t button34 : 1;
    uint8_t button35 : 1;
    uint8_t button36 : 1;
    uint8_t button37 : 1;
    uint8_t button38 : 1;
    int16_t rx_axis : 16;
    int16_t ry_axis : 16;
    int16_t rz_axis : 16;
  } dataForController_t;
#endif
