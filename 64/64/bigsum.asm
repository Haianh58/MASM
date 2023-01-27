extrn   GetStdHandle : proc
extrn   ReadFile : proc
extrn   WriteFile : proc
extrn   ExitProcess : proc

.data?
		num1	db	20	DUP(? )
		num2	db	20	DUP(? )
		KQ	db	20	DUP(? )
		nByte	dq ?

.data
		len1	dq	0
		len2	dq	0
		lenmin	dq	0
		Wnum1	db  'Nhap so num1 : ', 0
		Wnum2	db  'Nhap so num2 : ', 0
		WKQ	db  'Ket qua SUM  : ', 0

.code

main proc

	mov	rbp, rsp
	sub	rsp, 48h
	mov	rcx, -10
	call	GetStdHandle
	mov	[rbp - 8], rax			; hinput
	mov	rcx, -11
	call	GetStdHandle
	mov	[rbp - 10h], rax		; houtput
	xor	r12, r12


	mov	rcx, [rbp - 10h]
	mov	rdx, offset Wnum1
	mov	r8, sizeof Wnum1
	mov	r9, offset nByte
	mov		[rsp + 20h], r12
	call	WriteFile

	mov     rcx, [rbp - 8h]
	mov     rdx, offset num1
	mov     r8, 20
	mov     r9, offset nByte
	mov		[rsp + 20h], r12
	call    ReadFile

	mov		r13, offset num1
	push	r13
	call	length_of
	mov		len1, rax
	mov		BYTE PTR[r13 + rax], 0
	mov		BYTE PTR[r13 + rax + 1], 0




	mov	rcx, [rbp - 10h]
	mov	rdx, offset Wnum2
	mov	r8, sizeof Wnum2
	mov	r9, offset nByte
	mov	[rsp + 20h], r12
	call	WriteFile

	mov     rcx, [rbp - 8h]
	mov     rdx, offset num2
	mov     r8, 20
	mov     r9, offset nByte
	mov	[rsp + 20h], r12
	call    ReadFile

	mov	r13, offset num2
	push	r13
	call	length_of
	mov	len2, rax
	mov	BYTE PTR[r13 + rax], 0
	mov	BYTE PTR[r13 + rax + 1], 0
	



	mov	r13, offset num1
	push	r13
	call	reverse
	mov	r13, offset num2
	push	r13
	call	reverse
	mov	rax, len1
	cmp	rax, len2
	jg	L1
	cmp	rax, len2
	jle	L2

	L1 :
		mov	rax, len2
		mov	lenmin, rax
		mov	r13, offset num1
		push	r13
		mov	r13, offset num2
		push	r13
		push	lenmin
		call	add_two
		mov	r13, offset KQ
		push	r13
		call	reverse
		mov	rcx, [rbp - 10h]
		mov	rdx, offset WKQ
		mov	r8, sizeof WKQ
		mov	r9, offset nByte
		mov	[rsp + 20h], r12
		call	WriteFile

		mov	rcx, [rbp - 10h]
		mov	rdx, offset KQ
		mov	r8, sizeof	KQ
		mov	r9, offset nByte
		mov	[rsp + 20h], r12
		call	WriteFile

		mov	rcx, 0
		call	ExitProcess

	L2 :
		mov	rax, len2
		mov	lenmin, rax
		mov	r13, offset num2
		push	r13
		mov	r13, offset num1
		push	r13
		push	lenmin
		call	add_two
		mov		r13, offset KQ
		push	r13
		call	reverse
		
		mov	rcx, [rbp - 10h]
		mov	rdx, offset WKQ
		mov	r8, sizeof	WKQ
		mov	r9, offset nByte
		mov	[rsp + 20h], r12
		call	WriteFile
		
		mov	rcx, [rbp - 10h]
		mov	rdx, offset KQ
		mov	r8, 20
		mov	r9, offset nByte
		mov	[rsp + 20h], r12
		call	WriteFile
		
		mov	rcx, 0
		call	ExitProcess
		

main endp

add_two proc
	push	rbp
	mov	rbp, rsp
	mov	rcx, [rbp + 16]
	mov	rsi, [rbp + 24]
	mov	rdi, [rbp + 32]
	mov	rdx, offset KQ
	mov	rax, 0
	jmp	L1
	L2 :
		sub	al, 0Ah
		xor 	ah, ah
		mov	ah, 1
		jmp	L3
	L1 :
		mov	rbx, 0
		add	bh, ah
		mov	rax, 0
		mov	bl, BYTE PTR[rdi]
		mov	al, BYTE PTR[rsi]
		cmp	al, 0
		jz	L9
		sub	al, 30h
	L9 :
		sub	bl, 30h
		add	bl, bh
		add	al, bl
		cmp	al, 0Ah
		jge	L2
	L3 :
		add	al, 30h
		mov	BYTE PTR[rdx], al
		inc	rsi
		inc	rdi
		inc	rdx
		loop	L1

		mov	rbx, lenmin
		cmp	rbx, len1
		jne	L4
		jmp	L7

	L4 :
		mov	rbx, 0
		add	bh, ah
		mov	bl, BYTE PTR[rdi]
		cmp	bl, 0
		je	L7
		mov	rax, 0
		sub	bl, 30h
		add	bl, bh
		mov	rax, 0
		cmp	bl, 0Ah
		jge	L5

	L6 :
		add	bl, 30h
		mov	BYTE PTR[rdx], bl
		inc	rdx
		inc	rdi
		loop	L4

	L5 :
		sub	bl, 0Ah
		xor 	ah, ah
		mov	ah, 1
		jmp	L6

	L7 :
		cmp	ah, 1h
		je	L8
		inc	rdx
		mov	WORD PTR[rdx], 0A0Dh
		pop	rbp
		ret	24

	L8:
		mov	BYTE PTR[rdx], 1
		add	BYTE PTR[rdx], 30h
		inc	rdx
		mov	WORD PTR[rdx], 0A0Dh
		pop	rbp
		ret	24
add_two endp

reverse proc
	push	rbp
	mov	rbp, rsp
	mov	rsi, [rbp + 16]
	mov	rdi, [rbp + 16]
	mov	rcx, 0
	L1:
		mov	rax, 0
		mov	al, BYTE PTR[rsi]
		cmp	al, 0
		jz	L2
		push	rax
		inc	rsi
		inc	rcx
		jmp	L1
	L2 :
		mov	rax, 0
		pop	rax
		mov	BYTE PTR[rdi], al
		inc	rdi
		loop	L2
		pop	rbp
		ret	8

reverse endp

length_of proc
	push	rbp
	mov	rbp, rsp
	mov	rbx, [rbp + 16]
	mov	rax, 0

	L1:
		cmp	BYTE PTR[rbx], 0Dh
		jz	L2
		inc	rax
		inc	rbx
		jmp	L1

	L2 :
		pop	rbp
		ret	8
length_of endp
end