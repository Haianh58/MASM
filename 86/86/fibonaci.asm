.386
.model flat, stdcall
option casemap: none

include	\masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	n	db	10	dup(?)
	f0	db	'0', 20h, 0
	f1	db	'1', 20h, 0
	fn	db	100	dup(?)
	n1	dd	0

	F1	db	'1', 0
	F2	db	'0', 0
	cach	db	20h, 0

.code
main PROC
		push	10
		push	offset	n
		call	StdIn
		push	offset	n
		call	atoi
		mov		n1,eax

		cmp		n1, 0
		jz		@out1
		cmp		n1, 1
		jz		@out1
		
		jmp		@print01

	@out1:
		push	offset	f1
		call	StdOut
		jmp		@out
	@print01:
		push	offset	f0
		call	StdOut
		push	offset	f1
		call	StdOut

		mov		ebx, 2
		mov		eax, n1
		sub		eax, ebx
		mov		n1, eax

		push	offset	F1
		call	rev

		jmp		@fibo
	@fibo:
		mov		ebx, n1
		cmp		ebx, 0
		jz		@out

		push	offset	F1
		push	offset	F2
		push	offset	fn
		call	addnum

		push	offset	F1
		push	offset	F2
		call	cop

		push	offset	fn
		push	offset	F1
		call	cop

		push	offset	fn
		call	rev

		push	offset	fn
		call	StdOut

		push	offset	cach
		call	StdOut

		mov		ecx, n1
		dec		ecx
		mov		n1, ecx

		jmp		@fibo
	
	@out:
		ret



	push	0
	call	ExitProcess


main ENDP
addnum	PROC
		push	ebp
		mov		ebp,esp
		push	esi
		push	edx
		push	ecx
		mov		esi, [ebp+8]	;sum
		mov		edx, [ebp+12]	;so nho
		mov		ecx, [ebp+16]	;so lon
		xor		eax, eax
		xor		edi, edi


	@cong:
		xor		ebx, ebx				;4554
		add		bh, ah					;61
		xor		eax, eax				;0
		mov		bl,	byte ptr[ecx+edi]
		mov		al, byte ptr[edx+edi]
		cmp		al, 0
		jz		@next
		sub		bl, 30h
		sub		al, 30h
		add		bl, bh
		add		al, bl
		cmp		al,0Ah
		jge		@nho
	
	@chuyen:
		add		al,	30h
		mov		byte ptr[esi+edi], al
		inc		edi
		jmp		@cong

	@nho:
		sub		al, 0Ah
		mov		ah, 1
		jmp		@chuyen

	@next:				
		add		bh, ah					
		xor		eax, eax	
		mov		bl,	byte ptr[ecx+edi]
		cmp		bl, 0
		jz		@done
		sub		bl, 30h
		add		bl, bh
		cmp		bl,0Ah
		jge		@nho1
	@chuyen1:
		add		bl,	30h
		mov		byte ptr[esi+edi], bl
		inc		edi
		xor		ebx, ebx
		jmp		@next
	@nho1:
		sub		bl, 0Ah
		mov		ah, 1
		jmp		@chuyen1
	@done:
		cmp		bh,1
		je		@done1
		inc		edi
		mov		byte ptr [esi + edi], 0
		pop		ecx
		pop		edx
		pop		esi
		pop		ebp
		ret		12
	
	@done1:
		mov		bl, 1
		add		bl, 30h
		mov		byte ptr [esi + edi], bl
		inc		edi
		mov		byte ptr [esi + edi], 0
		pop		ecx
		pop		edx
		pop		esi
		pop		ebp
		ret		12


addnum	ENDP

cop	PROC
	push	ebp	
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]		
	mov		ebx, [ebp+08h]			
	xor		esi, esi


	@for:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		@done
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@for

	@done:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

cop	ENDP
rev PROC
	push	ebp
	mov		ebp, esp
	push	eax
	mov		eax, [ebp+08h]
	xor		esi, esi
	xor		edi, edi
	push	0h

	@for:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		@pop
		push	edx
		inc		esi
		jmp		@for

	@pop:
		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		@done
		mov		byte ptr [eax+edi], dl
		inc		edi
		jmp		@pop

	@done:
		mov		byte ptr [eax+edi], 0
		pop		eax
		pop		ebp
		ret		4
rev	ENDP

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






