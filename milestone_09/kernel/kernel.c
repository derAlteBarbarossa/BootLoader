#include "../drivers/screen.h"
#include "../cpu/isr.h"
#include "../cpu/idt.h"

void main ()
{
	clear_screen();

	print("Testing interrupts:\n");

	isr_install();
	__asm__ __volatile__("int $2");
	__asm__ __volatile__("int $3");

	return;

}
