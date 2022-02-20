# Automatically expand to a list of existing files that 
# match the patterns
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c util/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h util/*.h)

# Create a list of object files to build, simple by replacing 
# the ’.c’ extension of filenames in C_SOURCES with ’.o’
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o}

CFLAGS=-g

# Defaul build target
all: os-image

# This is the actual disk image that the computer loads
# which is the combination of our compiled bootsector and kernel 
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

# Link kernel object files into one binary, making sure the 
# entry code is right at the start of the binary.
kernel.bin: kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: kernel/kernel_entry.o ${OBJ}
	i386-elf-ld ${CFLAGS} -o $@ -Ttext 0x1000 $^

# Generic rule for building ’somefile.o’ from ’somefile.c’
%.o : %.c ${HEADERS}
	i386-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

# Assemble the kernel_entry.
%.o : %.s
	nasm $< -f elf -o $@

%.bin : %.s
	nasm $< -f bin -I 'boot/16bit/' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o

debug: os-image kernel.elf
	qemu-system-i386 -S -s -fda os-image

run: os-image
	qemu-system-i386 -fda os-image

