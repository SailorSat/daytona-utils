/* SailorSat Daytona USB
 *
 * Teensy RawHID example
 * http://www.pjrc.com/teensy/rawhid.html
 * Copyright (c) 2009 PJRC.COM, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above description, website URL and copyright notice and this permission
 * notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <avr/io.h>
#include <util/delay.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include "usb_gamepad.h"
#include "analog.h"

#define CPU_PRESCALE(n)	(CLKPR = 0x80, CLKPR = (n))

uint8_t bitLow(uint8_t data, uint8_t shift){
	return ((data & (1 << shift)) == 0 ? 1 : 0);
}

void getControllerData() {
	uint8_t bitC = PINC;
	uint8_t bitD = PIND;
	uint8_t bitE = PINE;

	// PORTC - buttons 1 to 8
	usbControllerState.button01 = bitLow(bitC, 7);	// C7
	usbControllerState.button02 = bitLow(bitC, 6);	// C6
	usbControllerState.button03 = bitLow(bitC, 5);	// C5
	usbControllerState.button04 = bitLow(bitC, 4);	// C4
	usbControllerState.button05 = bitLow(bitC, 3);	// C3
	usbControllerState.button06 = bitLow(bitC, 2);	// C2
	usbControllerState.button07 = bitLow(bitC, 1);	// C1
	usbControllerState.button08 = bitLow(bitC, 0);	// C0
	
	// PORTD - buttons 9 to 16
	usbControllerState.button09 = bitLow(bitD, 7);	// D7
	usbControllerState.button10 = bitLow(bitE, 0);	// E0 (as D6 is hardwired to the LED)
	usbControllerState.button11 = bitLow(bitD, 5);	// D5
	usbControllerState.button12 = bitLow(bitD, 4);	// D4
	usbControllerState.button16 = bitLow(bitD, 0);	// D0
	
	// unused buttons
	usbControllerState.button17 = 0;
	usbControllerState.button18 = 0;
	usbControllerState.button19 = 0;

	// OPTION0 (E6) - DECODE
	if (bitLow(bitE, 6)) {
		// decoder disabled
		usbControllerState.button13 = bitLow(bitD, 3);	// D3
		usbControllerState.button14 = bitLow(bitD, 2);	// D2
		usbControllerState.button15 = bitLow(bitD, 1);	// D1
		usbControllerState.button20 = 0;
		usbControllerState.button21 = 0;
		usbControllerState.button22 = 0;
		usbControllerState.button23 = 0;
		usbControllerState.button24 = 0;
		} else {
		// decoder active
		usbControllerState.button13 = 0;
		usbControllerState.button14 = 0;
		usbControllerState.button15 = 0;
		// Gear
		// 4=1+2/!3+4 = 4
		// 3=2/4      = 2
		// 2=1/3      = 1
		switch (bitLow(bitD, 3) + bitLow(bitD, 2) * 2 + bitLow(bitD, 1) * 4) {
			case 0x05:
			// gear 1
			usbControllerState.button20 = 0;
			usbControllerState.button21 = 1;
			usbControllerState.button22 = 0;
			usbControllerState.button23 = 0;
			usbControllerState.button24 = 0;
			break;

			case 0x06:
			// gear 2
			usbControllerState.button20 = 0;
			usbControllerState.button21 = 0;
			usbControllerState.button22 = 1;
			usbControllerState.button23 = 0;
			usbControllerState.button24 = 0;
			break;

			case 1:
			// gear 3
			usbControllerState.button20 = 0;
			usbControllerState.button21 = 0;
			usbControllerState.button22 = 0;
			usbControllerState.button23 = 1;
			usbControllerState.button24 = 0;
			break;

			case 2:
			// gear 4
			usbControllerState.button20 = 0;
			usbControllerState.button21 = 0;
			usbControllerState.button22 = 0;
			usbControllerState.button23 = 0;
			usbControllerState.button24 = 1;
			break;

			default:
			// neutral
			usbControllerState.button20 = 1;
			usbControllerState.button21 = 0;
			usbControllerState.button22 = 0;
			usbControllerState.button23 = 0;
			usbControllerState.button24 = 0;
		}
	}
	
	// get the analog data
	// OPTION1 (E7) - mode selection
	if (bitLow(bitE, 7)) {
		// flight stick mode
		usbControllerState.rz_axis = 0x0200;
		usbControllerState.z_axis = analogRead(2);
		usbControllerState.y_axis = analogRead(1);
		usbControllerState.x_axis = analogRead(0);
		} else {
		// racing mode
		usbControllerState.rz_axis = analogRead(2);
		usbControllerState.z_axis = analogRead(1);
		usbControllerState.y_axis = 0x0200;
		usbControllerState.x_axis = analogRead(0);
	}
}
	
void loop() {
	int8_t r = 0;
	uint8_t offset = 0;
	while (1) {
		// if we received data, do something with it
		r = usb_gamepad_read();
		if (r > 0) {
			offset = 0;
			while (offset < r) {
				uint8_t cmd = receiveBuffer[offset];
				uint8_t val = receiveBuffer[offset + 1];
				switch (cmd) {
					case 0x01:
					// 1 - drive board command
					PORTA = val;
					break;
					case 0x02:
					// 2 - lamp data
					PORTB = val;
					break;
				}
				offset+=3;
			}
		}

		// read data
		getControllerData();
		
		// finally, we send the data out via the USB port
		usb_gamepad_send();
	}
		
}

void setupPins() {
	// set port C, D and E as inputs with the pull-up enabled
	DDRC = 0x00;
	PORTC = 0xFF;

	DDRD = 0x00;
	PORTD = 0xFF;

	DDRE = 0x00;
	PORTE = 0xFF;

	// drive board connected on port A
	DDRA = 0xFF;
	PORTA = 0x00;
	
	// lamps connected on port B
	DDRB = 0xFF;
	PORTB = 0x00;
}

int main() {
	// Make sure our watchdog timer is disabled!
	wdt_reset();
	MCUSR &= ~(1 << WDRF);
	wdt_disable();

	// set for 16 MHz clock
	CPU_PRESCALE(0);

	// Initialize the USB, and then wait for the host to set configuration.
	// If the board is powered without a PC connected to the USB port,
	// this will wait forever.
	usb_init();
	while (!usb_configured()) /* wait */ ;

	// Wait an extra second for the PC's operating system to load drivers
	// and do whatever it does to actually be ready for input
	_delay_ms(1000);

	setupPins();
	
	// main loop
	loop();
}