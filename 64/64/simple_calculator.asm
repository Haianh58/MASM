extrn GetStdHandle		:proc
extrn ReadFile			:proc
extrn WriteFile			:proc
extrn GetProcessHeap	:proc
extrn HeapAlloc			:proc
extrn ExitProcess		:proc

.data
	sSelect		db "Select operator: ", 0Ah, "1. cong", 0Ah, "2. tru", 0Ah, "3. nhan", 0Ah, "4. chia", 0Ah, "0. Exit", 0Ah, 0h
	sSelect2	db  "Chon che do ", 0h
	sInput		db "Nhap ", 0h
	sOutput		db "KQ = ", 0h
	sRemain		db "Remainder = ", 0h

.data?
	select		db 5 dup(?)
	num1		db 100 dup(?)
	num2		db 100 dup(?)
	result		dq 0
	remain		dd 0
	negt		db ?
	nByte		dd 0

.code
main proc
	mov		rbp, rsp
	sub		rsp, 48h

	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp - 08h], rax				;hInout
	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp - 10h], rax				;hOutput

	xor		r15, r15

	mov		rcx, [rbp - 10h]
	mov		rdx, offset sSelect
	mov		r8, sizeof sSelect
	mov		r9, offset nByte
	mov		[rsp + 20h], r15
	call	WriteFile

	@batdau:
		mov		negt, 0
		mov		rcx, [rbp - 10h]
		mov		rdx, offset sSelect2
		mov		r8, sizeof sSelect2
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	WriteFile
		
		mov		rcx, [rbp - 08h]
		mov		rdx, offset select
		mov		r8, 5
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	ReadFile

		mov		r14b, select
		cmp		r14b, '0'						; neu = 0  exit
		jz		@Exit
		cmp		r14b, '4'						;neu > 4  quay lai
		jg		@batdau

		mov		rcx, [rbp - 10h]
		mov		rdx, offset sInput
		mov		r8, sizeof sInput
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	WriteFile

		mov		rcx, [rbp - 08h]
		mov		rdx, offset num1
		mov		r8, 100
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	ReadFile						
		mov		rsi, offset num1
		call	atoi
		mov		r12, rax						

		mov		rcx, [rbp - 08h]
		mov		rdx, offset num2
		mov		r8, 100
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	ReadFile						
		mov		rsi, offset num2
		call	atoi
		mov		r13, rax						

		mov		r14b, select
		cmp		r14b, '1'						
		jz		@Add
		cmp		r14b, '2'
		jz		@Sub
		cmp		r14b, '3'
		jz		@Mul
		cmp		r14b, '4'
		jz		@Div

	@Add:
		add		r12, r13
		mov		result, r12
		jmp		@PrintResult
	@Sub:
		push	r12
		sub		r12, r13
		js		NegResult
		mov		result, r12
		jmp		@PrintResult
		NegResult:
			mov		negt, 1						;cmp negative = 1 --> so am
			pop		r12
			sub		r13, r12
			mov		result, r13
			jmp		@PrintResult
	@Mul:
		mov		rax, r12
		mul		r13
		mov		result, rax
		jmp		@PrintResult
	@Div:
		xor		rdx, rdx
		mov		rax, r12
		div		r13
		mov		result, rax
		mov		remain, edx

	@PrintResult:								
		mov		rcx, [rbp - 10h]
		mov		rdx, offset sOutput
		mov		r8, sizeof sOutput
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	WriteFile
		mov		rsi, result
		call	itoa
		cmp		negt, 1
		jz		addsub

	@next:
		mov		word ptr [rsi + rax], 0A0Dh
		add		rax, 2
		mov		rcx, [rbp - 10h]
		mov		rdx, rsi
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rbp + 20h], r15
		call	WriteFile

	mov		dl, select
	cmp		dl, '4'						;if select = 4 --> div
	jz		@PrintRemain
	jmp		@startCalc

	@PrintRemain:						;print remain
		mov		rcx, [rbp - 10h]
		mov		rdx, offset sRemain
		mov		r8, sizeof sRemain
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	WriteFile
		xor		rsi, rsi
		mov		esi, remain
		call	itoa
		mov		word ptr [rsi + rax], 0A0Dh
		add		rax, 2
		mov		rcx, [rbp - 10h]
		mov		rdx, rsi
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rsp + 20h], r15
		call	WriteFile
		jmp		@batdau

	addsub:
		dec		rsi
		mov		byte ptr [rsi], '-'
		inc		rax
		jmp		@next
	@Exit:
		xor		rcx, rcx
		call	ExitProcess

main endp

atoi proc			
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rdx
	xor		rax, rax
	mov		rbx, 10

	@TextNum:
		xor		rdx, rdx
		mov		dl, byte ptr [rsi]
		cmp		dl, '0'
		jl		@Exit
		cmp		dl, '9'
		jg		@Exit
		sub		dl, 30h
		add		rax, rdx
		mul		rbx
		inc		rsi
		jmp		@TextNum

	@Exit:
		xor		rdx, rdx
		div		rbx
		pop		rdx
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret
atoi endp

itoa proc			
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rdx
	mov		rbx, rsi

	sub		rsp, 20h
	call	GetProcessHeap
	mov		rcx, rax
	mov		rdx, 0
	mov		r8, 10
	call	HeapAlloc
	add		rsp, 20h
	mov		rdi, rax
	add		rdi, 20

	mov		rsi, rdi
	mov		rax, rbx
	mov		rbx, 10

	@NumText:
		xor		rdx, rdx
		div		rbx
		add		dl, 30h
		mov		byte ptr [rdi], dl
		dec		rdi
		test	rax, rax
		jz		@Exit
		jmp		@NumText

	@Exit:	
		sub		rsi, rdi
		mov		rax, rsi
		mov		rsi, rdi
		inc		rsi
		pop		rdx
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret
itoa endp
end