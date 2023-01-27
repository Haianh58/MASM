extrn   GetStdHandle: proc
extrn   ReadFile: proc
extrn   WriteFile: proc
extrn   ExitProcess: proc

.data?
	input		db	100	DUP(?)
	input1		db	20	DUP(?)
	output		db	20	DUP(?)
	nByte		dq	?

.data
	dem			dq	0
	len1		dq	0
	space		db	0Ah,0
	check		dq	1
	line_feed	db	20h, 0

.code

main proc
	mov	rbp, rsp 
	sub	rsp, 48h

	mov	rcx, -10
	call	GetStdHandle
	mov	[rbp - 8h], rax     ;hinput

	mov	rcx, -11
	call	GetStdHandle
	mov	[rbp - 10h], rax	;houtput

	xor	r12, r12

	mov     rcx, [rbp - 8h]
   	mov     rdx, offset input
   	mov     r8, 100
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    ReadFile

	mov     rcx, [rbp - 8h]
    mov     rdx, offset input1
    mov     r8, 20
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    ReadFile

	mov	r13, offset input1
	push	r13
	call	length_of
	mov	len1, rax

	mov	rsi, offset input
	mov	rdi, offset input1
	mov	rbx, 0 
	mov	rax, 0
L1:
	mov	rdx, 0 
	mov	rax, 0
	mov	dl, BYTE PTR [rsi + rbx]
	mov	dh, BYTE PTR [rdi + rax]
	cmp	dl, 0Ah
	jz	L5
	cmp	dl,dh
	je	L2
	inc	ebx
	jmp	L1

L2:
	mov	rdx, 0
	mov	dl,	BYTE PTR [rsi + rbx]
	mov	dh,	BYTE PTR [rdi + rax]
	cmp	dh, 0Dh
	jz	L3
	inc	rbx
	inc	rax
	cmp	dh,dl
	je	L2
	jmp	L1

L3:
	cmp	check, 0
	jz	L6
	mov	rax, 0
	mov	rax, dem
	inc	rax
	mov	dem, rax
	sub	rbx, len1
	inc	rbx
	jmp	L1

L5:
	cmp	check, 0
	jz	L7
	push	dem
	mov	r13, offset output 
	push	r13
	call	itoa

	mov	rcx, [rbp - 10h]
	mov	rdx, offset output
	mov	r8, 20
	mov	r9, offset nByte
	mov	[rsp+20h],r12
	call	WriteFile
	
	mov	rcx, [rbp - 10h]
	mov	rdx, offset space
	mov	r8, 2
	mov	r9, offset nByte
	mov	[rsp+20h],r12
	call	WriteFile


	mov	check, 0
	mov	rbx, 0
	mov	rax, 0
	jmp 	L1

L6:
	mov	rax, 0
	mov	rax, rbx
	sub	rax, len1
	push	rax
	mov	r13, offset output
	push	r13
	call	itoa

	mov	rcx, [rbp - 10h]
	mov	rdx, offset output
	mov	r8, 20
	mov	r9, offset nByte
	mov	[rsp+20h],r12
	call	WriteFile
	
	mov	rcx, [rbp - 10h]
	mov	rdx, offset line_feed
	mov	r8, 2
	mov	r9, offset nByte
	mov	[rsp+20h],r12
	call	WriteFile
	sub	rbx, len1
	inc 	rbx
	jmp	L1


L7:	
	mov	rcx, 0
	call	ExitProcess
	

main endp

itoa proc
	push    rbp
	mov     rbp, rsp
	push	rbx
	push	rcx
	push	rax
	push	rsi
	push	rdi
	xor	rax, rax
	xor	rbx, rbx
   	mov     rax, [rbp + 24]						
   	mov     rbx, [rbp + 16]						
   	mov		rsi, 0 
   	mov     rcx, 10
   	push    3Ah										

L1:
    xor     rdx, rdx
    div     rcx									
    or      rdx, 30h						
    push    rdx									
    cmp     rax, 0 						
    jz      L2
    jmp     L1

L2:

    pop     rdx
    cmp     dl, 3Ah								
    jz      L3						
    mov     BYTE PTR [rbx + rsi], dl			
    inc     rsi
    jmp     L2

L3:

	pop	rdi
	pop	rsi
	pop	rax
	pop	rcx
	pop	rbx
    	pop     rbp
    	ret     16
itoa endp

length_of proc
	push	rbp
	mov	rbp, rsp
	mov	rcx, [rbp+16]
	xor	rsi, rsi
	xor	rax, rax
		
L1:
	cmp	BYTE PTR [rcx+rsi], 0Dh
	jz	L2
	inc	rsi
	jmp	L1

L2:
	mov	rax, rsi
	pop	rbp
	ret	8
length_of endp
end