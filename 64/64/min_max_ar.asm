extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data?
    num_array	db	40 DUP (?)
    num_output	db	40 DUP (?)
    num		db	40 DUP (?)
    len		dq	?
    nByte	dq	?
.data
    sSizeReq    	db  'Nhap kich thuoc mang n: ', 0
    sArrReq     	db  'Nhap n phan tu cua mang: ', 0
    sMinResult  	db  'Min: ', 0
    sMaxResult  	db  'Max: ', 0
    max		   	dq	0
    min		    	dq	1000000
    space		db  20h, 0

.code
main proc
    mov     rbp, rsp
    sub     rsp, 48h

    mov     rcx, -10
    call    GetStdHandle
    mov     [rbp - 8h], rax     ;hInput
    
    mov     rcx, -11
    call    GetStdHandle
    mov     [rbp - 10h], rax    ;hOutput
    
    xor     r12, r12
    mov     rcx, [rbp - 10h]
    mov     rdx, offset sSizeReq
    mov     r8, sizeof sSizeReq
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

    mov     rcx, [rbp - 8h]
    mov     rdx, offset num_array
    mov     r8, 10
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    ReadFile

    mov     r13, offset num_array
    push    r13
    call    ATOI
    mov     len, rax

    mov     rcx, [rbp - 10h]
    mov     rdx, offset sArrReq
    mov     r8, sizeof sArrReq
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

	L1 :
		xor		r12, r12
		mov     rcx, [rbp - 8h]
		mov     rdx, offset num_array
		mov     r8, 10
		mov     r9, offset nByte
		mov     [rsp + 20h], r12
		call    ReadFile
		mov	rsi, offset num_array
		mov	rdi, offset num

	L2 :
		cmp	byte ptr[rsi], 0Dh
		je      L4
		cmp	byte ptr[rsi], 20h
		je      L3
		mov	rax, [rsi]
		mov	[rdi], rax
		inc	rdi
		inc	rsi
		jmp	L2

	L3 :
		mov	byte ptr[rdi], 0Dh
		mov	rbx, rsi
		mov	r12, offset num
		push	r12
		call	ATOI
		mov	rsi, rbx
		call	compare@			;So sanh max min
		dec	len
		inc	rsi
		mov	rdi, offset num
		jmp	L2
	L4 :
		mov	byte ptr[rdi], 0Dh
		mov	rbx, rsi
		mov	r12, offset num
		push	r12
		call	ATOI
		mov	rsi, rbx
		call	compare@
		dec	len
		cmp	len, 0
		je	L5
		jmp	L1

	L5 :
		push	max
		mov	r12, offset num_output
		push	r12
		call	REATOI

		xor     r12, r12
		mov     rcx, [rbp - 10h]
		mov     rdx, offset num_output
		mov     r8, sizeof num_output
		mov     r9, offset nByte
		mov     [rsp + 20h], r12
		call    WriteFile

		xor	r12, r12
		mov     rcx, [rbp - 10h]
		mov     rdx, offset space
		mov     r8, sizeof space
		mov     r9, offset nByte
		mov	[rsp + 20h], r12
		call    WriteFile
		
		mov	r13, min
		push	r13
		mov	r12, offset num_output
		push	r12
		call	REATOI

		xor	r12, r12
		mov     rcx, [rbp - 10h]
		mov     rdx, offset num_output
		mov     r8, sizeof num_output
		mov     r9, offset nByte
		mov	[rsp + 20h], r12
		call    WriteFile

		mov	rcx, 0
		call	ExitProcess


MAIN ENDP

compare@ PROC
	
	push	rbp
	mov	rbp, rsp
	mov	rbx, 0
	mov	rbx, rax
	cmp	rbx, max
	jg	L3
	jmp	L2

	L2:
		cmp	rbx, min
		jl	L5
		pop	rbp
		ret
	L5:
		mov	min, rbx
		pop	rbp
		ret
	L3:
		mov	max, rbx
		jmp	L2

compare@ ENDP
ATOI PROC
	push	rbp
	mov	rbp, rsp
	push	rbx
	mov	rbx, [rbp+16]
	xor	rsi, rsi								
	xor	rax, rax
	mov	rcx, 10
L1:
	xor	rdx,rdx
	mov	dl, byte ptr [rbx+rsi]				
	cmp	dl, 0Dh								
	jz	L2
	sub 	rdx, 30h							
	add	rax, rdx							
	mul	rcx									
	inc	rsi									
	jmp	L1

L2:
	xor	rdx, rdx
	div	rcx
	pop	rbx
	pop	rbp
	ret	8
ATOI ENDP

REATOI PROC

    push    rbp
    mov     rbp, rsp
    xor	    rax, rax
    xor	    rbx, rbx
    mov     rax, [rbp + 24]						
    mov     rbx, [rbp + 16]						
    xor     rsi, rsi 
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
    mov     byte ptr [rbx + rsi], dl			
    inc     rsi
    jmp     L2

L3:
    mov	    r8w, 0000h 
    mov     word ptr [rbx + rsi], r8w
    pop     rbp
    ret     16
REATOI ENDP
end