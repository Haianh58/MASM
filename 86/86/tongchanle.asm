.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
		n		db	40	dup(?)
		n_out	db	40	dup(?)
		tongle		dd	0
		tongchan	dd	0
		cach	db	20h, 0
		n1		dd	?


.code
main PROC
		push	40
		push	offset	n
		call StdIn

		push	offset	n
		call	atoi
		mov		n1, eax
		

	@for:
		cmp		n1, 0
		jz		break

		push	40
		push	offset n
		call	StdIn
		dec		n1

		push	offset n
		call	atoi

		mov		ebx,eax
		xor		edx,edx
		mov		ecx, 2
		div		ecx
		cmp		edx,0
		jz		@chan
		jmp		@le
	@chan:
		add		tongchan, ebx
		jmp		@for
	@le:
		add		tongle, ebx
		jmp		@for

	break:
		push	tongle
		push	offset	n_out
		call	itoa
		push	offset	n_out
		call	StdOut

		push	offset	cach
		call	StdOut

		push	tongchan
		push	offset	n_out
		call	itoa
		push	offset	n_out
		call	StdOut

main ENDP

atoi PROC
		push	ebp
		mov		ebp,esp
		push	ebx
		mov		ebx,[ebp+8]
		xor		esi,esi
		xor		eax,eax
		mov		ecx,10

	lap:
		xor		edx,edx
		mov		dl, byte ptr[ebx+esi]
		cmp		dl,0
		jz		break
		sub		edx,30h
		add		eax,edx
		mul		ecx
		inc		esi
		jmp		lap
	break:
		div		ecx
		pop		ebx
		pop		ebp
		ret		4
atoi ENDP

itoa PROC
		push	ebp
		mov		ebp,esp
		push	eax
		push	ebx
		mov		eax,[ebp+12]
		mov		ebx,[ebp+8]
		xor		esi,esi
		mov		ecx,10
		push	0h
	
	L1:
		xor		edx,edx
		div		ecx
		add		edx, 30h
		push	edx
		cmp		eax, 0
		jz		L2
		jmp		L1
	L2:
		pop		edx
		cmp		dl,0
		jz		break
		mov		byte ptr[ebx+esi],dl
		inc		esi
		jmp		L2
	break:
		mov		byte ptr[ebx+esi],0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP




end main