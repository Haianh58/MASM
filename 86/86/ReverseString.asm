.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	s1	db	40	dup(?)

.code
main PROC
	push	40

	push	offset	s1
	call	StdIn

	push	offset	s1
	call	reverse

	push	offset	s1
	call	StdOut

	push	0
	call	ExitProcess
	
main ENDP

reverse PROC
		push	ebp
		mov		ebp,esp
		mov		esi, [ebp+8]
		mov		edx, [ebp+8]
		push	0h
	L1:
		xor		eax,eax
		mov		al, byte ptr[esi]
		cmp		al,0
		jz		L2
		push	eax
		inc		esi
		jmp		L1

	L2:
		xor		eax,eax
		pop		eax
		cmp		al, 0
		jz		break
		mov		byte ptr[edx],al
		inc		edx
		jmp		L2
	break:
		pop		ebp
		ret		4

	

reverse ENDP
end main