.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	message db 40 dup(?)

.code
main PROC
	push	40
	push	offset message
	call	StdIn
	mov		eax,0
	uppercase:
		cmp	message[eax],0
		jz	input
		cmp	message[eax], 'a'
		jl	jum
		cmp	message[eax], 'z'
		jg	jum
		sub	message[eax], 20h
	jum:
		inc	eax
		jmp	uppercase
	input:
		push	offset	message
		call	StdOut
		push	0
		call	ExitProcess
main ENDP
END main
