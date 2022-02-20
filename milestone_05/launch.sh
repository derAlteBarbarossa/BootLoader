#!/bin/sh

nasm boot_sect.s -f bin -o boot_sect.bin


qemu-system-i386 -fda boot_sect.bin
