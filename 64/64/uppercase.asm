extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data 
	msg		db "input: ", 0h
	msg1	db "output: ", 0h
.data?
	string	db 100 dup(?)
	nByte	dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	;input
	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset msg
	mov		r8, sizeof msg
	mov		r9, offset nByte
	mov		[rsp+20], rbx
	call	WriteFile
	
	;read
	mov		rcx, -10
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset string
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile

	mov		r12, offset string
	push	r12
	call	Uppercase

	xor		rbx, rbx

	;out
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset msg1
	mov		r8, sizeof msg1
	mov		r9, offset nByte
	mov		[rsp+20], rbx
	call	WriteFile

	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset string
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		ecx, 0
	call	ExitProcess
main ENDP

Uppercase PROC
	push	rbp
	mov		rbp, rsp
	mov		rax, [rbp+16]
L1:
	cmp		BYTE PTR [rax], 0Dh
	jz		input
	cmp		BYTE PTR [rax], 'a'
	jl		nhay
	cmp		BYTE PTR [rax], 'z'
	jg		nhay
	sub		BYTE PTR [rax], 20h
nhay :
	inc	rax
	jmp	L1
input:
	pop	rbp
	ret	


Uppercase ENDP

end