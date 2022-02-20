#include "../drivers/screen.h"
#include "../cpu/isr.h"
#include "../cpu/idt.h"
#include "../util/int_to_ascii.h"

void main ()
{
	clear_screen();

	//print("Testing interrupts:\n");

	isr_install();
	//__asm__ __volatile__("int $2");
	//__asm__ __volatile__("int $3");

	asm volatile("sti");
	//init_timer(1000);
	init_keyboard();
	return;

}
