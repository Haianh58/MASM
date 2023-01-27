extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	Hello	db "Hello, World!", 0Ah, 0h

.data?
	nByte	dd 0
.code
main proc
	mov		rbp, rsp
	sub		rsp, 28h					;Shadow Space + Align

	mov		rcx, -11					;stdout
	call	GetStdHandle				;Return to rax

	xor		rbx, rbx

	mov		rcx, rax					;Handle
	mov		rdx, offset Hello			
	mov		r8, sizeof Hello
	mov		r9, offset nByte			;Return Value Agrument
	mov		[rsp + 20h], rbx			;Overlap
	call	WriteFile					;WriteFile (cx, dx, r8, r9)

	xor		rcx, rcx				
	call	ExitProcess

main endp
end