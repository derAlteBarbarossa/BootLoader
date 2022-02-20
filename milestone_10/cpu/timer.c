#include "timer.h"

uint32_t tick = 0;

static void timer_callback(registers_t regs)
{
	tick++;

	print("Tick: ");

	char tick_string[256];

	int_to_ascii(tick, tick_string);

	print(tick_string);

	print("\n");
}


void init_timer(uint32_t frequency)
{
	register_interrupt_handler(IRQ0, timer_callback);

	uint32_t divisor = PIT_FREQ/frequency;

	uint8_t low = (uint8_t) (divisor && 0xFF);
	uint8_t high = (uint8_t) ((divisor >> 8) && 0xFF);

	port_byte_out(0x43, 0x36);		// 0x43 is address of the Command/Mode Register for PIT
						// 0x36 = 0b00110110:
						//			bits[6:7]: 00  -> Channel 0
						//			bits[4:5]: 11  -> Access Mode: lobyte/hibyte
						//			bits[1:3]: 011 -> Operatring Mode: Mode 3 (square wave generator)
						//			bits[0]:0      -> BCD/Binary mode: 16-bit binary
	port_byte_out(0x40, low);	
	port_byte_out(0x40, high);	
}
