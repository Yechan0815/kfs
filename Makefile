CC			= gcc
LD			= ld
NASM		= nasm
RM			= rm -rf

CFLAGS		= -m32 -fno-builtin -fno-exceptions -fno-stack-protector -nostdlib -nodefaultlibs #-fno-rtti 

LINKER		= linker.ld

BOOT		= boot.asm
INIT		= init.c

INCS		= include
SRCS		= $(addprefix arch/i386/boot/, $(BOOT)) \
				$(addprefix init/, $(INIT))

OBJS		= $(patsubst %.asm,%.o,$(SRCS)) $(patsubst %.c,%.o,$(SRCS))
OBJS		:= $(filter %.o,$(OBJS))

BIN			= kfs
ISO			= kfs.iso

all:		$(OBJS) link iso

%.o: %.asm
			@$(NASM) -f elf32 $< -o $@
			@echo "NASM\t" $@

%.o: %.c
			@$(CC) $(CFLAGS) -I$(INCS) -c $< -o $@
			@echo "CC\t" $@

link:
			@$(LD) -m elf_i386 -T $(LINKER) -o $(BIN) $(OBJS) 
			@echo "LD\t" $(BIN)

iso:	
			@grub-file --is-x86-multiboot $(BIN)
			@mkdir -p iso/boot/grub
			@echo menuentry \"kfs\" { > iso/boot/grub/grub.cfg
			@echo "\t" multiboot /boot/$(BIN) >> iso/boot/grub/grub.cfg
			@echo } >> iso/boot/grub/grub.cfg
			@cp $(BIN) iso/boot/$(BIN)
			@grub-mkrescue -o $(ISO) iso
			@$(RM) iso 
			@echo "IMAGE\t" $(ISO)

run:
			qemu-system-i386 -s -cdrom $(ISO)

clean:
			$(RM) $(OBJS)

fclean: clean
			$(RM) $(BIN) $(ISO)

re: fclean all
