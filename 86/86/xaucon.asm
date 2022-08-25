.386
.model flat, stdcall 
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
		s			db	100 dup(?)
		scon		db	10	dup(?)
		len			dd	0
		ca			db	10	dup(?)
		ans			db	100	dup(?)
		d			dd	0



.code
main PROC
		push	100
		push	offset	s
		call	StdIn

		push	10
		push	offset	scon
		call	StdIn	

		push	offset	scon
		call	strlen
		mov		len, eax

		push	offset	s
		push	offset	scon
		call	find

		push	offset	ans
		call	StdOut

		push	0
		call	ExitProcess

main ENDP

find PROC
		push	ebp
		mov		ebp,esp
		push	eax
		push	ebx
		mov		eax, [ebp+8]
		mov		ebx, [ebp+12]
		xor		esi, esi

	@for:
		xor		edx, edx
		xor		edi, edi
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		@done
		mov		dh, byte ptr [eax]
		cmp		dl,dh
		jmp		@ss
		inc		esi
		jmp		@for
	@ss:
		xor		edx, edx
		mov		dl, byte ptr[eax+edi]
		cmp		dl, 0
		jz		@out
		mov		dh, byte ptr[ ebx+esi]
		cmp		dl,dh
		jnz		@for
		inc		edi	
		inc		esi
		jmp		@ss

	@out:
		sub		esi, len	
		push	esi
		push	offset ca
		call	itoa
		add		esi, len

		push	offset	ca
		push	offset	ans
		push	d
		call	printt
		jmp		@for
	@done:
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
find	ENDP

printt PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]
	mov		ebx, [ebp+0Ch]
	mov		ecx, [ebp+08h]
	xor		edi, edi

	@for:
		xor		edx, edx
		mov		dl, byte ptr [eax+edi]
		cmp		dl, 0
		jz		@done
		mov		byte ptr [ebx+ecx], dl
		inc		ecx
		inc		edi
		jmp		@for

	@done:
		mov		byte ptr [ebx+ecx], 20h
		inc		ecx
		mov		byte ptr [ebx+ecx], 0
		mov		d, ecx
		xor		edi, edi
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
printt ENDP

strlen	PROC		;do dai xau
		push	ebp
		mov		ebp,esp
		push	ecx
		mov		ecx,[ebp+8]
		xor		esi,esi

	@str:
		cmp		byte ptr[ecx+esi], 0
		jz		break
		inc		esi
		jmp		@str
		
	break:
		mov		eax,esi
		pop		ecx
		pop		ebp
		ret		4
strlen ENDP
itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	mov		ecx, 10
	xor		edi, edi
	push	0h

	@for:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		@pop
		jmp		@for

	@pop:
		pop		edx
		cmp		dl, 0h
		jz		@break
		mov		byte ptr [ebx+edi], dl
		inc		edi
		jmp		@pop

	@break:
		mov		byte ptr [ebx+edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP

end main

