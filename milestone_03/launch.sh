#!/bin/sh

nasm boot_sect.s -f bin -o boot_sect.bin


qemu-system-i386 boot_sect.bin
