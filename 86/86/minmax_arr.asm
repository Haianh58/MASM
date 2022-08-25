.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
		n		db	40 dup(?)
		n_out	db	40	dup(?)
		max		dd	0
		min		dd	100000
		n1		dd	?
		cach	db	20h, 0


.code
main PROC
		push	40
		push	offset	n
		call	StdIn

		push	offset	n
		call	atoi
		mov		n1,eax

	@for:
		cmp		n1, 0
		jz		break
		push	40

		push	offset	n
		call	StdIn
		dec		n1

		push	offset	n
		call	atoi

		mov		ebx, eax

		cmp		ebx,min
		jl		minn

		cmp		ebx, max
		jg		maxx

		jmp		@for

	maxx:
		mov		max, ebx
		jmp		@for
	minn:
		mov		min, ebx
		jmp		@for

	break:
		push	min
		push	offset	n_out
		call	itoa
		push	offset	n_out
		call	StdOut

		push	offset	cach
		call	StdOut

		push	max
		push	offset	n_out
		call	itoa
		push	offset	n_out
		call	StdOut

	push	0
	call	ExitProcess





main ENDP

atoi PROC
		push	ebp
		mov		ebp,esp
		push	ebx
		mov		ebx, [ebp+8]
		xor		esi, esi
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
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+12]					;eax=sum 
	mov		ebx, [ebp+8]					;ebx=s
	xor		esi, esi
	mov		ecx, 10						
	push	0h

	@div:
		xor		edx, edx
		div		ecx							;edx = eax % ecx, eax /= ebx
		add		edx, 30h					;+48
		push	edx
		cmp		eax, 0
		jz		@pop
		jmp		@div

	@pop:
		pop		edx
		cmp		dl, 0h
		jz		@done
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@pop

	@done:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP


end main