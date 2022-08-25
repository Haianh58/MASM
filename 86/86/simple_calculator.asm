.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
		chon	db		"1.Add", 0Ah, "2.Sub", 0Ah, "3.Mul", 0Ah, "4.Div", 0
		a		db		30	dup(?)
		b		db		0	dup(?)
		xuong	db 0Ah, 0
		input	db	4	dup(?)
		n1		dd	0
		n2		dd	0
		cong	db	" + ", 0
		tru		db	" - ", 0
		nhan	db	" * ", 0
		chia	db	" / ", 0
		bang	db	" = ", 0
		ans		dd	0
		ot		db	30 dup(?)
		k		dd	0
		h		db	"choose number: ", 0
		num1	db	"Num1: ", 0
		num2	db	"Num2: ", 0
.code
main PROC
		push	offset	chon
		call	StdOut

		push	offset	xuong
		call	StdOut

		push	offset	h
		call	StdOut
		push	4
		push	offset	input
		call	StdIn
		push	offset	input
		call	atoi
		mov		k, eax

		
		push	offset	xuong
		call	StdOut

		push	offset num1
		call	StdOut
		push	30
		push	offset	a
		call	StdIn
		push	offset	a
		call	atoi
		mov		n1,eax

		push	offset	num2
		call	StdOut
		push	30
		push	offset	b
		call	StdIn
		push	offset b
		call	atoi
		mov		n2,eax

		mov		ecx, k
		cmp		ecx, 1
		jz		@add
		cmp		ecx, 2
		jz		@sub
		cmp		ecx, 3
		jz		@mul
		cmp		ecx, 4
		jz		@div
		jmp		break

	@add:
		push	offset	a
		call	StdOut
		push	offset	cong
		call	StdOut
		push	offset	b
		call	StdOut
		push	offset	bang
		call	StdOut

		mov		ebx, n1
		add		ebx, n2
		mov		ans, ebx
		jmp		break
	@sub:
		push	offset	a
		call	StdOut
		push	offset	tru
		call	StdOut
		push	offset	b
		call	StdOut
		push	offset	bang
		call	StdOut
		
		mov		ebx, n1
		sub		ebx, n2
		mov		ans, ebx
		jmp		break
	@mul:
		push	offset	a
		call	StdOut
		push	offset	nhan
		call	StdOut
		push	offset	b
		call	StdOut
		push	offset	bang
		call	StdOut

		mov		eax, n1
		mov		ebx, n2
		mul		ebx
		mov		ans, eax
		jmp		break
	@div:
		push	offset	a
		call	StdOut
		push	offset	chia
		call	StdOut
		push	offset	b
		call	StdOut
		push	offset	bang
		call	StdOut

		mov		eax,n1
		mov		ebx,n2
		div		ebx
		mov		ans, eax
		jmp		break

	break:
		push	ans
		push	offset	ot
		call	itoa
		push	offset	ot
		call	StdOut

		push	0
		call	ExitProcess
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