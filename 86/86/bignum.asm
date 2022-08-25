.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
		a		db	30	dup(?)
		b		db	30	dup(?)
		len1	dd	0
		len2	dd	0
		sum		db	30	dup(?)
		len		dd	0

.code
main PROC
		push	30
		push	offset	a
		call	StdIn
		push	offset	a
		call	strlen
		mov		len1,eax

		push	30
		push	offset	b
		call	StdIn
		push	offset	b
		call	strlen
		mov		len2,eax

		push	offset	a		;dao nguoc xau
		call	rev
		push	offset	b
		call	rev

		mov		ebx, len1		;so sanh do dai xau
		cmp		len2, ebx		;len2>=len1
		jge		@TH1
		cmp		len2, ebx		;len2<len1
		jl		@TH2			
	
	@TH1:
		mov		ebx,len1
		mov		len, ebx
		push	offset	b
		push	offset	a
		jmp		@done
	@TH2:
		mov		ebx,len2
		mov		len, ebx
		push	offset	a
		push	offset	b
		jmp		@done
	@done:
		push	offset	sum
		call	ADD_Num

		push	offset	sum
		call	rev

		push	offset	sum	
		call	StdOut

		push	0
		call	ExitProcess
	
main ENDP

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

rev	PROC
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

rev ENDP

ADD_Num	PROC
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

ADD_Num ENDP
end main