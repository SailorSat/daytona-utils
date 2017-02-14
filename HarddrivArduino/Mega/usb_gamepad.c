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
#define USB_PRIVATE_INCLUDE
#include "usb_gamepad.h"
#include <string.h>

/**************************************************************************
 *
 *  Configurable Options
 *
 **************************************************************************/
// You can change these to give your code its own name.
#define STR_MANUFACTURER	L"SEGA"
#define STR_PRODUCT				L"Daytona USB"
#define STR_SERIAL				L"1"

// These numbers identify your device.  Set these to
// something that is (hopefully) not used by any others!
#define VENDOR_ID			0x0CA3
#define PRODUCT_ID		0x3CFC

// These determine the bandwidth that will be allocated
// for your communication.  You do not need to use it
// all, but allocating more than necessary means reserved
// bandwidth is no longer available to other USB devices.
#define GAMEPAD_DATA_SIZE	64	// input packet size

/**************************************************************************
 *
 *  Endpoint Buffer Configuration
 *
 **************************************************************************/
#define ENDPOINT0_SIZE	64

#define GAMEPAD_INTERFACE	0

#define GAMEPAD_DATA_ENDPOINT	1

#define GAMEPAD_INPUT_BUFFER	EP_SINGLE_BUFFER

static const uint8_t PROGMEM endpoint_config_table[] = {
	1, EP_TYPE_INTERRUPT_IN,  EP_SIZE(GAMEPAD_DATA_SIZE) | GAMEPAD_INPUT_BUFFER,
	1, EP_TYPE_INTERRUPT_OUT, EP_SIZE(GAMEPAD_DATA_SIZE) | GAMEPAD_INPUT_BUFFER,
	0,
	0
};

/**************************************************************************
 *
 *  Descriptor Data
 *
 **************************************************************************/
// Descriptors are the data that your computer reads when it auto-detects
// this USB device (called "enumeration" in USB lingo).  The most commonly
// changed items are editable at the top of this file.  Changing things
// in here should only be done by those who've read chapter 9 of the USB
// spec and relevant portions of any USB class specifications!
static const uint8_t PROGMEM device_descriptor[] = {
	0x12,															// bLength
	0x01,															// bDescriptorType
	0x00, 0x02,												// bcdUSB
	0x00,															// bDeviceClass
	0x00,															// bDeviceSubClass
	0x00,															// bDeviceProtocol
	ENDPOINT0_SIZE,										// bMaxPacketSize0
	LSB(VENDOR_ID), MSB(VENDOR_ID),		// idVendor
	LSB(PRODUCT_ID), MSB(PRODUCT_ID),	// idProduct
	0x00, 0x01,												// bcdDevice
	0x01,															// iManufacturer
	0x02,															// iProduct
	0x03,															// iSerialNumber
	0x01															// bNumConfigurations
};

static const uint8_t PROGMEM gamepad_hid_report_desc[] = {
	0x05, 0x01,											// USAGE_PAGE (Generic Desktop)
	0x09, 0x04,											// USAGE (Joystick)
	0xA1, 0x01,											// COLLECTION (Application)

	0x95, 0x08,											//   REPORT_COUNT (8)
	0x75, 0x10,											//   REPORT_SIZE (16)
	0x16, 0x00, 0x00,								//   LOGICAL_MINIMUM 0
	0x26, 0xFF, 0x03,								//   LOGICAL_MAXIMUM (1024)
	0x36, 0x00, 0x00,								//   PHYSICAL_MINIMUM (0)
	0x46, 0xFF, 0x03,								//   PHYSICAL_MAXIMUM (1024)
	0x09, 0x30,											//   USAGE (X)
	0x09, 0x31,											//   USAGE (Y)
	0x09, 0x32,											//   USAGE (Z)
	0x09, 0x33,											//   USAGE (Rx)
	0x09, 0x34,											//   USAGE (Ry)
	0x09, 0x35,											//   USAGE (Rz)
	0x09, 0x36,											//   USAGE (Slider)
	0x09, 0x37,											//   USAGE (Dial)
	0x81, 0x02,											//   INPUT (Data,Var,Abs)

	0x95, 0x18,											//   REPORT_COUNT (24)
	0x75, 0x01,											//   REPORT_SIZE (1)
	0x15, 0x00,											//   LOGICAL_MINIMUM (0)
	0x25, 0x01,											//   LOGICAL_MAXIMUM (1)
	0x35, 0x00,											//   PHYSICAL_MINIMUM (0)
	0x45, 0x01,											//   PHYSICAL_MAXIMUM (1)
	0x05, 0x09,											//   USAGE_PAGE (Button)
	0x19, 0x01,											//   USAGE_MINIMUM (Button 1)
	0x29, 0x18,											//   USAGE_MAXIMUM (Button 24)
	0x81, 0x02,											//   INPUT (Data,Var,Abs)

	0x05, 0x08,											//   USAGE_PAGE (LEDs)
	0x09, 0x4B,											//   USAGE (Generic Indicator)
	0x95, 0x18,											//   REPORT_COUNT (24)
	0x75, 0x01,											//   REPORT_SIZE (1)
	0x91, 0x20,											//   OUTPUT (Data,Var,Abs)

	0xC0														// END_COLLECTION
};

#define CONFIG1_DESC_SIZE		(9+9+9+7)
#define GAMEPAD_HID_DESC_OFFSET	(9+9)
static const uint8_t PROGMEM config1_descriptor[CONFIG1_DESC_SIZE] = {
	// configuration descriptor, USB spec 9.6.3, page 264-266, Table 9-10
	0x09,										// bLength;
	0x02,										// bDescriptorType;
	LSB(CONFIG1_DESC_SIZE),	// wTotalLength
	MSB(CONFIG1_DESC_SIZE),
	0x01,										// bNumInterfaces
	0x01,										// bConfigurationValue
	0x00,										// iConfiguration
	0x80,										// bmAttributes (Bus Powered)
	0x32,										// bMaxPower (100 mA)

	// interface descriptor, USB spec 9.6.5, page 267-269, Table 9-12
	0x09,								// bLength
	0x04,								// bDescriptorType
	GAMEPAD_INTERFACE,	// bInterfaceNumber
	0x00,								// bAlternateSetting
	0x01,								// bNumEndpoints
	0x03,								// bInterfaceClass (0x03 = HID)
	0x00,								// bInterfaceSubClass (0x00 = No Boot)
	0x00,								// bInterfaceProtocol (0x00 = No Protocol)
	0x00,								// iInterface

	// HID interface descriptor, HID 1.11 spec, section 6.2.1
	0x09,															// bLength
	0x21,															// bDescriptorType
	0x11, 0x01,												// bcdHID
	0x00,															// bCountryCode
	0x01,															// bNumDescriptors
	0x22,															// bDescriptorType
	sizeof(gamepad_hid_report_desc),	// wDescriptorLength
	0x00,
	
	// endpoint descriptor, USB spec 9.6.6, page 269-271, Table 9-13
	0x07,														// bLength
	0x05,														// bDescriptorType
	GAMEPAD_DATA_ENDPOINT | 0x80,	// bEndpointAddress
	0x03,														// bmAttributes (0x03=intr)
	GAMEPAD_DATA_SIZE,							// wMaxPacketSize
	0x00,
	0x0A														// bInterval (10ms)
};

// If you're desperate for a little extra code memory, these strings
// can be completely removed if iManufacturer, iProduct, iSerialNumber
// in the device desciptor are changed to zeros.
struct usb_string_descriptor_struct {
	uint8_t bLength;
	uint8_t bDescriptorType;
	int16_t wString[];
};
static const struct usb_string_descriptor_struct PROGMEM string0 = {
	4,
	3,
	{0x0409}
};
static const struct usb_string_descriptor_struct PROGMEM string1 = {
	sizeof(STR_MANUFACTURER),
	3,
	STR_MANUFACTURER
};
static const struct usb_string_descriptor_struct PROGMEM string2 = {
	sizeof(STR_PRODUCT),
	3,
	STR_PRODUCT
};
static const struct usb_string_descriptor_struct PROGMEM string3 = {
	sizeof(STR_SERIAL),
	3,
	STR_SERIAL
};

// This table defines which descriptor data is sent for each specific
// request from the host (in wValue and wIndex).
static const struct descriptor_list_struct {
	uint16_t	wValue;
	uint16_t	wIndex;
	const uint8_t	*addr;
	uint8_t		length;
} PROGMEM descriptor_list[] = {
	{0x0100, 0x0000, device_descriptor, sizeof(device_descriptor)},
	{0x0200, 0x0000, config1_descriptor, sizeof(config1_descriptor)},
	{0x2100, GAMEPAD_INTERFACE, config1_descriptor+GAMEPAD_HID_DESC_OFFSET, 9},
	{0x2200, GAMEPAD_INTERFACE, gamepad_hid_report_desc, sizeof(gamepad_hid_report_desc)},
	{0x0300, 0x0000, (const uint8_t *)&string0, 4},
	{0x0301, 0x0409, (const uint8_t *)&string1, sizeof(STR_MANUFACTURER)},
	{0x0302, 0x0409, (const uint8_t *)&string2, sizeof(STR_PRODUCT)},
	{0x0303, 0x0409, (const uint8_t *)&string3, sizeof(STR_SERIAL)}
};
#define NUM_DESC_LIST (sizeof(descriptor_list)/sizeof(struct descriptor_list_struct))

/**************************************************************************
 *
 *  Variables - these are the only non-stack RAM usage
 *
 **************************************************************************/
// zero when we are not configured, non-zero when enumerated
static volatile uint8_t usb_configuration = 0;

// these are a more reliable timeout than polling the
// frame counter (UDFNUML)
static volatile uint8_t tx_timeout_count=0;

static uint8_t gamepad_idle_config = 0;

// protocol setting from the host.  We use exactly the same report
// either way, so this variable only stores the setting since we
// are required to be able to report which setting is in use.
static uint8_t gamepad_protocol = 1;

/**************************************************************************
 *
 *  Public Functions - these are the API intended for the user
 *
 **************************************************************************/

// initialize USB
void usb_init(void) {
	HW_CONFIG();
	USB_FREEZE();				// enable USB
	PLL_CONFIG();				// config PLL
        while (!(PLLCSR & (1<<PLOCK))) ;	// wait for PLL lock
        USB_CONFIG();				// start USB clock
        UDCON = 0;				// enable attach resistor
	usb_configuration = 0;
        UDIEN = (1<<EORSTE)|(1<<SOFE);
	sei();
}

// return 0 if the USB is not configured, or the configuration
// number selected by the HOST
uint8_t usb_configured(void) {
	return usb_configuration;
}

gamepad_state_t usbControllerState;
uint8_t receiveBuffer[64];
uint8_t rxBuffer[64];
int8_t rxOffset;

// send a input packet
int8_t usb_gamepad_send(void) {
	uint8_t intr_state, i;

	// if we're not online (enumerated and configured), error
	if (!usb_configuration) return -1;
	intr_state = SREG;
	cli();
	tx_timeout_count = 50;
	UENUM = GAMEPAD_DATA_ENDPOINT;
	// wait for the FIFO to be ready to accept data
	while (1) {
		if (UEINTX & (1<<RWAL)) break;
		SREG = intr_state;
		if (tx_timeout_count == 0) return 0;
		if (!usb_configuration) return -1;
		intr_state = SREG;
		cli();
		UENUM = GAMEPAD_DATA_ENDPOINT;
	}

	for (i=0; i<sizeof(gamepad_state_t); i++) {
		UEDATX = ((uint8_t*)&usbControllerState)[i];
	}

	// transmit it now
	UEINTX = 0x3A;
	SREG = intr_state;
	return 1;
}

// read a input packet, with timeout
int8_t usb_gamepad_read()
{
	int8_t result = rxOffset;
	memcpy(receiveBuffer, rxBuffer, rxOffset);
	rxOffset = 0;
	return result;
}

/**************************************************************************
 *
 *  Private Functions - not intended for general user consumption....
 *
 **************************************************************************/

ISR(USB_GEN_vect)
{
	uint8_t intbits, t;

	intbits = UDINT;
	UDINT = 0;
	if (intbits & (1<<EORSTI)) {
		UENUM = 0;
		UECONX = 1;
		UECFG0X = EP_TYPE_CONTROL;
		UECFG1X = EP_SIZE(ENDPOINT0_SIZE) | EP_SINGLE_BUFFER;
		UEIENX = (1<<RXSTPE);
		usb_configuration = 0;
	}
	if ((intbits & (1<<SOFI)) && usb_configuration) {
		t = tx_timeout_count;
		if (t) tx_timeout_count = --t;
	}
}

// Misc functions to wait for ready and send/receive packets
static inline void usb_wait_in_ready(void)
{
	while (!(UEINTX & (1<<TXINI))) ;
}
static inline void usb_send_in(void)
{
	UEINTX = ~(1<<TXINI);
}
static inline void usb_wait_receive_out(void)
{
	while (!(UEINTX & (1<<RXOUTI))) ;
}
static inline void usb_ack_out(void)
{
	UEINTX = ~(1<<RXOUTI);
}

// USB Endpoint Interrupt - endpoint 0 is handled here.  The
// other endpoints are manipulated by the user-callable
// functions, and the start-of-frame interrupt.
//
ISR(USB_COM_vect)
{
	uint8_t intbits;
	const uint8_t *list;
	const uint8_t *cfg;
	uint8_t i, n, len, en;
	uint8_t bmRequestType;
	uint8_t bRequest;
	uint16_t wValue;
	uint16_t wIndex;
	uint16_t wLength;
	uint16_t desc_val;
	const uint8_t *desc_addr;
	uint8_t	desc_length;

	UENUM = 0;
	intbits = UEINTX;
	if (intbits & (1<<RXSTPI)) {
		bmRequestType = UEDATX;
		bRequest = UEDATX;
		wValue = UEDATX;
		wValue |= (UEDATX << 8);
		wIndex = UEDATX;
		wIndex |= (UEDATX << 8);
		wLength = UEDATX;
		wLength |= (UEDATX << 8);
		UEINTX = ~((1<<RXSTPI) | (1<<RXOUTI) | (1<<TXINI));
		if (bRequest == GET_DESCRIPTOR) {
			list = (const uint8_t *)descriptor_list;
			for (i=0; ; i++) {
				if (i >= NUM_DESC_LIST) {
					UECONX = (1<<STALLRQ)|(1<<EPEN);  //stall
					return;
				}
				desc_val = pgm_read_word(list);
				if (desc_val != wValue) {
					list += sizeof(struct descriptor_list_struct);
					continue;
				}
				list += 2;
				desc_val = pgm_read_word(list);
				if (desc_val != wIndex) {
					list += sizeof(struct descriptor_list_struct)-2;
					continue;
				}
				list += 2;
				desc_addr = (const uint8_t *)pgm_read_word(list);
				list += 2;
				desc_length = pgm_read_byte(list);
				break;
			}
			len = (wLength < 256) ? wLength : 255;
			if (len > desc_length) len = desc_length;
			do {
				// wait for host ready for IN packet
				do {
					i = UEINTX;
				} while (!(i & ((1<<TXINI)|(1<<RXOUTI))));
				if (i & (1<<RXOUTI)) return;	// abort
				// send IN packet
				n = len < ENDPOINT0_SIZE ? len : ENDPOINT0_SIZE;
				for (i = n; i; i--) {
					UEDATX = pgm_read_byte(desc_addr++);
				}
				len -= n;
				usb_send_in();
			} while (len || n == ENDPOINT0_SIZE);
			return;
		}
		if (bRequest == SET_ADDRESS) {
			usb_send_in();
			usb_wait_in_ready();
			UDADDR = wValue | (1<<ADDEN);
			return;
		}
		if (bRequest == SET_CONFIGURATION && bmRequestType == 0) {
			usb_configuration = wValue;
			usb_send_in();
			cfg = endpoint_config_table;
			for (i=1; i<5; i++) {
				UENUM = i;
				en = pgm_read_byte(cfg++);
				UECONX = en;
				if (en) {
					UECFG0X = pgm_read_byte(cfg++);
					UECFG1X = pgm_read_byte(cfg++);
				}
			}
			UERST = 0x1E;
			UERST = 0;
			return;
		}
		if (bRequest == GET_CONFIGURATION && bmRequestType == 0x80) {
			usb_wait_in_ready();
			UEDATX = usb_configuration;
			usb_send_in();
			return;
		}

		if (bRequest == GET_STATUS) {
			usb_wait_in_ready();
			i = 0;
			if (bmRequestType == 0x82) {
				UENUM = wIndex;
				if (UECONX & (1<<STALLRQ)) i = 1;
				UENUM = 0;
			}
			UEDATX = i;
			UEDATX = 0;
			usb_send_in();
			return;
		}
		if ((bRequest == CLEAR_FEATURE || bRequest == SET_FEATURE)
		  && bmRequestType == 0x02 && wValue == 0) {
			i = wIndex & 0x7F;
			if (i >= 1 && i <= MAX_ENDPOINT) {
				usb_send_in();
				UENUM = i;
				if (bRequest == SET_FEATURE) {
					UECONX = (1<<STALLRQ)|(1<<EPEN);
				} else {
					UECONX = (1<<STALLRQC)|(1<<RSTDT)|(1<<EPEN);
					UERST = (1 << i);
					UERST = 0;
				}
				return;
			}
		}
		if (wIndex == GAMEPAD_INTERFACE) {
			if (bmRequestType == 0xA1) {
				if (bRequest == HID_GET_REPORT) {
					usb_wait_in_ready();
					for (i = ENDPOINT0_SIZE; i; i--){
						// just send zeros
						UEDATX = 0;
					}						
					usb_send_in();
					return;
				}
				if (bRequest == HID_GET_IDLE) {
					usb_wait_in_ready();
					UEDATX = gamepad_idle_config;
					usb_send_in();
					return;
				}
				if (bRequest == HID_GET_PROTOCOL) {
					usb_wait_in_ready();
					UEDATX = gamepad_protocol;
					usb_send_in();
					return;
				}
			}
			if (bmRequestType == 0x21) {
				if (bRequest == HID_SET_REPORT) {
					usb_wait_receive_out();
					if (rxOffset <= 60) {
						rxBuffer[rxOffset] = UEDATX;
						rxBuffer[rxOffset + 1] = UEDATX;
						rxBuffer[rxOffset + 2] = UEDATX;
						rxOffset += 3;
					}
					usb_ack_out();
					usb_wait_in_ready();
					usb_send_in();
					return;
				}
				if (bRequest == HID_SET_IDLE) {
					gamepad_idle_config = (wValue >> 8);
					usb_send_in();
					return;
				}
				if (bRequest == HID_SET_PROTOCOL) {
					gamepad_protocol = wValue;
					usb_send_in();
					return;
				}
			}
		}
	}
	UECONX = (1<<STALLRQ) | (1<<EPEN);	// stall
}
