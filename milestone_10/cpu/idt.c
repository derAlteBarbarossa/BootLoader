#include "idt.h"

void set_idt_gate(int interrupt_number, uint32_t handler) 
{
	idt[interrupt_number].low_offset = handler & 0xFFFF;
	idt[interrupt_number].sel = 0x08;
	idt[interrupt_number].always0 = 0;
	idt[interrupt_number].flags = 0x8E; 
	idt[interrupt_number].high_offset = (handler >> 16) & 0xFFFF;
}

void set_idt()
{
	idt_reg.base = (uint32_t) &idt;
	idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;
	/* Don't make the mistake of loading &idt -- always load &idt_reg */
	__asm__ __volatile__("lidtl (%0)" : : "r" (&idt_reg));
}
