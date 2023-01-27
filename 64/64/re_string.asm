extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	
.data?
	string1		db	30 DUP (?)
	nByte		dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	xor		rbx, rbx

	mov		rcx, -10
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset string1
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile

	mov		r12, offset string1
	push	r12
	call	RE

	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset string1
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		ecx, 0
	call	ExitProcess

main ENDP

RE PROC
	
	push	rbp
	mov		rbp, rsp
	mov		rsi, [rbp+16]
	mov		rdi, [rbp+16]
	mov		rcx, 0
L1:	
	mov		rax, 0
	mov		al,	BYTE PTR [rsi]
	cmp		al, 0Dh
	jz		L2
	push	rax
	inc		rsi
	inc		rcx
	jmp		L1
L2:			
	mov		rax, 0
	pop		rax
	mov		BYTE PTR [rdi],al
	inc		rdi
	loop	L2
	pop		rbp
	ret		8
	
RE ENDP

END