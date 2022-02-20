#/bin/sh

nasm boot_sect.s -f bin -o boot_sect.bin
#nasm boot_sect.s -f elf -o boot_sect.elf
#objdump -D boot_sect.elf > boot_sect.asm
