# DIR=

all: os_image.bin

run: all
	qemu-system-x86_64 -drive format=raw,media=disk,file=os_image.bin 


os_image.bin: boot_sector.bin kernel.bin
	cat $^ > $@
	truncate $@ -s 10240

# Build the kernel binary
kernel.bin: kernel.o
	ld -o $@ -Ttext 0x7e00 $< -m elf_i386 --oformat binary

# Build the kernel object file
kernel.o:
	gcc -ffreestanding -fno-pie -c syscore/kernel/kernel_entry.c -o $@ -m32

# build the kernel entry object file
boot_sector.bin:
	nasm ./boot/boot_sector.asm -f bin -o $@


clean:
	rm -fr *.o *.bin




# # ----------------------------------------------------------------------------

# Automatically expand to a list of sources using wildcards
# C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
# HEADERS = $(wildcard kernel/*.h drivers/*.h)
 
# # TODO: Make sources dep on all header files

# # Convert the *. c filenames to *. o to give a list of object files to build
# OBJ = ${C_SOURCES:.c=.o}


# # Default build target
# all: os_image.bin

# # Run qemu to simulate booting of our code
# run: all
# 	qemu-system-x86_64 -drive format=raw,media=disk,file=os_image.bin 


# os_image.bin: boot_sector.bin kernel.bin
# 	cat $^ > $@
# 	truncate $@ -s 10240

# # Link kernel object files into one binary, making sure the
# kernel.bin: kernel/kernel_entry.o ${OBJ}
# # entry code is right at the start of the binary
# 	ld -o $@ -tText 0x7e00 $^ -m elf_i386 --oformat binary


# %.o : %.c ${HEADERS}
# 	gcc -ffreestanding -c $< -o $@


# boot_sector.bin: 
# 	nasm ./boot/boot_sector.asm -f bin -o $@

# clean:
# 	rm -fr *.bin *.dis *.o os_image.bin
# 	rm -fr kernel/*.o boot/*.bin drivers/*.o













