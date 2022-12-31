global start

section .multiboot
		dd 0x1BADB002
		dd 0x0
		dd -0x1BADB002

section .bss
stack_bottom:
		resb 16384 ; 16 KiB
stack_top:

section .text
		extern start_kernel

start:
		mov esp, stack_top

		call start_kernel
		cli
.hang	hlt
		jmp .hang
