
# This is the actual disk image that the computer loads,
# which is the combination of our compiled bootsector and kernel os-image: boot_sect.bin kernel.bin
all: os-image

os-image: boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files: # - the kernel_entry, which jumps to main() in our kernel
# - the compiled C kernel
kernel.bin: kernel_entry.o kernel.o
	i386-elf-ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

# Build our kernel object file.
kernel.o : kernel.c
	i386-elf-gcc -ffreestanding -c $< -o $@

# Build our kernel entry object file.
kernel_entry.o : kernel_entry.s
	nasm $< -f elf -o $@

#Assemble the boot sector to raw machine code
#	The -I options tells nasm where to find our useful assembly
#	routines that we include in boot_sect.asm
boot_sect.bin : boot_sect.s
	nasm $< -f bin -I ’../16bit/’ -o $@

# Clear away all generated files.
clean:
	rm -fr *.bin *.dis *.o os-image *.map

# Disassemble our kernel - might be useful for debugging.
kernel.dis : kernel.bin 
	ndisasm -b 32 $< > $@

run:
	qemu-system-i386 -fda os-image	

