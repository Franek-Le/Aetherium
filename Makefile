GCCPARAMS = -m32 -fno-stack-protector -fno-builtin -I source/kernel/ -I source/kernel/utils/ -nostdlib -fno-use-cxa-atexit -fno-rtti -fno-exceptions -fno-leading-underscore -fpermissive

all: build clean

build:
	gcc $(GCCPARAMS) -c source/kernel/kernel.cpp -o kernel.o
	gcc $(GCCPARAMS) -c source/kernel/gdt/gdt.cpp -o gdt.o
	gcc $(GCCPARAMS) -c source/kernel/port/port.cpp -o port.o
	gcc $(GCCPARAMS) -c source/kernel/interrupts/interrupts.cpp -o interrupts.o
	
	nasm -f elf32 source/boot/boot.asm -o boot.o
	nasm -f elf32 source/kernel/interrupts/interruptstubs.asm -o interruptstubs.o

	ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o gdt.o port.o interrupts.o interruptstubs.o
	mv kernel Aetherium/boot/kernel
	grub-mkrescue -o Aetherium.iso Aetherium/

clean:
	rm -f *.o