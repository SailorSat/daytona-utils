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

#define RXLED 4
#define TXLED 5

#define CPU_PRESCALE(n)	(CLKPR = 0x80, CLKPR = (n))

// Initializes the USART to receive and transmit,
//  takes in a value you can find in the datasheet
//  based on desired communication and clock speeds
void USART_Init(uint16_t baudSetting){
	// Set baud rate
	UBRR1 = baudSetting;
	// Enable receiver and transmitter
	UCSR1B = (1<<RXEN1)|(1<<TXEN1);
	// Set frame format: 8data, 1stop bit
	UCSR1C = (1<<UCSZ10)|(1<<UCSZ11);	
}

unsigned char USART_Read( void ){
	// Wait for data to be received
	while ( !(UCSR1A & (1<<RXC1)) ){
	}
	// Get and return received data from buffer
	return UDR1;
}


// This sends out a byte of data via the USART.
void USART_Write( unsigned char data )
{
	// Wait for empty transmit buffer
	while ( !( UCSR1A & (1<<UDRE1)) ){
	}
	// Put data into buffer, sends the data
	UDR1 = data;
}

unsigned char USART_ReadB( uint8_t offset ){
	uint8_t timeout = 25;
	USART_Write(0);
	USART_Write(offset);
	offset += 1;
	// Wait for data to be received 
	while ( !(UCSR1A & (1<<RXC1)) ){
		_delay_ms(1);
		timeout--;
		if (timeout == 0){
			return 0xff;
		}			
	}	
	// Get and return received data from buffer 
	return UDR1;
}

// Get a 16 bit value off the serial port by doing two successive reads
//  Assumes that data is being transmitted high byte first
int16_t USART_ReadI( uint8_t offset ){
	int16_t returnValue = 0;
	returnValue = USART_ReadB(offset);
	offset += 1;
	returnValue += USART_ReadB(offset) << 8;
	return returnValue;
}

void USART_Flush( void )
{
	unsigned char dummy;
	while ( UCSR1A & (1<<RXC1) )
		dummy = UDR1;
}

// This turns on one of the LEDs hooked up to the chip
void LEDon(char ledNumber){
	DDRD |= 1 << ledNumber;
	PORTD &= ~(1 << ledNumber);
}

// And this turns it off
void LEDoff(char ledNumber){
	DDRD &= ~(1 << ledNumber);
	PORTD |= 1 << ledNumber;
}

int main( void ) {
	// Make sure our watchdog timer is disabled!
	wdt_reset(); 
	MCUSR &= ~(1 << WDRF); 
	wdt_disable();

	// set for 16 MHz clock
	CPU_PRESCALE(0);

	// Initialize the USART for serial communications
	// 3 corresponds to 250000 baud - see datasheet for more values
	USART_Init(3);

	// Initialize the USB, and then wait for the host to set configuration.
	// If the board is powered without a PC connected to the USB port,
	// this will wait forever.
	LEDon(RXLED);
	usb_init();
	while (!usb_configured()) /* wait */ ;
	LEDoff(RXLED);

	// Wait an extra second for the PC's operating system to load drivers
	// and do whatever it does to actually be ready for input
	// This wait also gives the Arduino bootloader time to timeout,
	//  so the serial data you'll be properly aligned.
	LEDon(TXLED);
	_delay_ms(1000);
	LEDoff(TXLED);
	
	LEDon(RXLED);
	while (USART_Read() != 0xA5) {
	}
	LEDoff(RXLED);

	int8_t r = 0;
	uint8_t offset = 0;
	while (1) {
		// if we received data, do something with it
		r = usb_gamepad_read();
		if (r > 0) {
			LEDon(RXLED);
			offset = 0;
			while (offset < r) {
				USART_Write(receiveBuffer[offset]);
				USART_Write(receiveBuffer[offset + 1]);
				offset+=3;
			}
			LEDoff(RXLED);
		}
		
		// we get our data from the ATmega328p by writing 0x00 and the offset and then wait for the
		// ATmega328p to send that back to us.
		LEDon(TXLED);
		USART_Flush();
		
		// report 1 - 1st mouse
		offset = 0;
		usbControllerState1.report = USART_ReadB(offset);
		offset += 1;
		usbControllerState1.buttons = USART_ReadB(offset);
		offset += 1;
		usbControllerState1.x_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState1.y_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState1.z_axis = USART_ReadI(offset);
		offset += 2;

		// report 2 - 2nd mouse
		usbControllerState2.report = USART_ReadB(offset);
		offset += 1;
		usbControllerState2.buttons = USART_ReadB(offset);
		offset += 1;
		usbControllerState2.x_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState2.y_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState2.z_axis = USART_ReadI(offset);
		offset += 2;
		
		// report 3 - 3rd mouse
		usbControllerState3.report = USART_ReadB(offset);
		offset += 1;
		usbControllerState3.buttons = USART_ReadB(offset);
		offset += 1;
		usbControllerState3.x_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState3.y_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState3.z_axis = USART_ReadI(offset);
		offset += 2;
		
		// report 4 - joystick
		usbControllerState4.report = USART_ReadB(offset);
		offset += 1;
		usbControllerState4.buttons = USART_ReadB(offset);
		offset += 1;
		usbControllerState4.rx_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState4.ry_axis = USART_ReadI(offset);
		offset += 2;
		usbControllerState4.rz_axis = USART_ReadI(offset);
		offset += 2;
		
		// communication with the arduino chip is done here
		LEDoff(TXLED);

		// finally, we send the data out via the USB port
		usb_gamepad_send1();
		usb_gamepad_send2();
		usb_gamepad_send3();
		usb_gamepad_send4();
	}
}