# Implicit rules for common extensions
.SUFFIXES: .o .asm .c .bin

# Compiler and linker configuration
AS = nasm
# CC = gcc -m32 -ffreestanding -nostartfiles -nostdlib -fno-pic 
CC = gcc -g -m32 -fno-stack-protector -fno-builtin -fno-pic
LD = ld -m elf_i386 -Ttext 0x1000 --oformat binary #-Ttext 0x1000
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)


# Target directories
OBJDIR = obj
BINDIR = bin

# Object files
OBJS = $(OBJDIR)/kmain.o $(OBJDIR)/ports.o  $(OBJDIR)/screen.o $(OBJDIR)/kprint.o

# Targets
all: run

run: $(BINDIR)/kernel.bin
	qemu-system-i386 -drive format=raw,file=$<

$(BINDIR)/kernel.bin: $(BINDIR)/loader.bin $(BINDIR)/kmain.bin
	cat $^ > $@

$(BINDIR)/kmain.bin: $(OBJDIR)/kmain_entry.o $(OBJS) 
	$(LD) -o $@ $^

# $(BINDIR)/kmain.elf: $(OBJDIR)/kmain_entry.o $(OBJS)
# 	$(LD) -o $@ $^

$(OBJDIR)/%.o: src/boot/%.asm
	$(AS) $< -f elf -o $@

$(OBJDIR)/%.o: src/kernel/%.c
	$(CC) -c $< -o $@

$(OBJDIR)/%.o: src/drivers/%.c
	$(CC) -c -g $< -o $@

$(BINDIR)/loader.bin: src/boot/loader.asm
	$(AS) $< -f bin -o $@

diss: bin/kmain.bin
	ndisasm -b 32 -o 0x1000 bin/kmain.bin  > dissasm/kmaind.asm 
# 	qemu-system-i386 -s -fda bin/kernel.bin &
# 	gdb -ex "target remote localhost:1234" -ex "symbol-file bin/kmain.elf"

debug: bin/kernel.bin
	qemu-system-i386 -s -S bin/kernel.bin

clean:
	rm -f $(OBJDIR)/* $(BINDIR)/* dissasm/*
