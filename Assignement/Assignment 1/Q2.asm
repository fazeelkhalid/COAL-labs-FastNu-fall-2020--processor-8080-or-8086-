[org 0x0100]
jmp main
clearScreen:
	; save ax,es,di value in stack;
	push ax;
	push es;
	push di;
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
	nextchar: 
	mov word [es:di], 0x0720 ; print space on screen
	add di, 2; move at next screen location
	cmp di, 4000 ; check is all screen cleared?
	jne nextchar; if all screen not cleared then jump;
	;pop ax,es,di value from stack
	pop di;
	pop es;
	pop di;
	ret

DisplayCharacter:
	pop cx ; save Ip value
	mov ax,0xb800; load video base in ax
	mov es,ax; point es to video base
	mov di,1984; point di to top left column
	mov bx,0; bx = count processed bit
	; pop from stack and store it in dx
	DisplayCharacterLoop1:
		pop dx;
		add dx,0X30; add 30 in dx for getting ascii number
		mov dh,07; put character property;
		mov word [es:di], dx ; print " > " on screen in red color
		add di,2; // move at next position
		add bx,1;
		cmp bx,16;
		jb DisplayCharacterLoop1
	push cx;
	ret


hexToBinary:
	;push ax,bx in stack
	pop cx;save Ip
	;bx = indicate which bit is under processing
	mov ax,[Input]
	jmp loop1

	zeroBit:; it will execute when carry flag = 0
		push 0;
		jmp InsideLoop1;

	loop1:
		shr ax,1;one bit Shift Logical Right 
		jnc zeroBit;
		push 1;
		InsideLoop1:
		add bx,1;
		cmp bx,16;
		jne loop1;
	;now pop ax, bx from stack
	push cx;
	ret

main:
	call clearScreen
	call hexToBinary;
	call DisplayCharacter
 mov ax, 0x4c00 ; terminate program
 int 0x21
 Input: dw 0x7F2F;
 