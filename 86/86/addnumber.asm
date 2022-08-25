.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	a db 10 dup(?)
	b db 10 dup(?)
	s db 10 dup(?)
	sum			dd 0

.code
main PROC
	push	10
	push	offset a
	call	StdIn

	push	10
	push	offset b
	call	StdIn

	push	offset a
	call	fun
	mov		sum, eax

	push	offset b
	call	fun
	add		sum, eax

	push	sum
	push	offset s
	call	itoa

	push	offset s
	call	StdOut

	push    0
    call    ExitProcess
main ENDP
fun PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+8]
	xor		esi, esi							;Xóa d? li?u trong thanh ghi
	xor		eax, eax							;esi,eax=0
	mov		ecx, 10

	lap:
		xor		edx,edx
		mov		dl,	byte ptr [ebx+esi]			;mov 1 byte(8 bit) ebx sang dl
		cmp		dl, 0							;so sanh voi 0
		jz		break							;jump neu dl=0
		
		sub		dl, 30h							;chuyen ve int
		add		eax, edx
		mul		ecx								;nhan eax voi 10

		inc		esi								;esi++
		jmp		lap

	break:
		div		ecx
		pop		ebx
		pop		ebp
		ret		4
fun ENDP
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

