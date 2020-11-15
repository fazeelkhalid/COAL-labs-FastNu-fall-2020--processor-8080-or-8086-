[org 0x0100]
; ax store input decimal number 
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
	mov ax,[x]; store x cordinates in ax for multiply
	mov bx, 160;
	mul bx;
	mov di,ax; point di to top left column
	mov bx,[y] ; store y cordinates in bx
	add bx,[y]; ; ass 1 character take 2 byte
	add di,bx;
	
	mov bx,0; bx = count processed bit
	; pop from stack and store it in dx
	jmp DisplayCharacterLoop1;
	letter:
		mov dh,04;
		add dx,0X37
		jmp insideDisplayCharacterLoop1;
	
	DisplayCharacterLoop1:
		pop dx;	
		cmp dx,0X09
		ja letter;
		
		mov dh,07;
		add dx,0X30; add 30 in dx for getting ascii number
		
		insideDisplayCharacterLoop1:
		mov word [es:di], dx ; print on screen in white color
		add di,2; // move at next position
		add bx,1;
		cmp bx,4;
		jb DisplayCharacterLoop1
	push cx;
	ret

decimalToHex:
	mov dx,0;
	pop si; store Ip
	mov bx, 16;
	mov cx, 0; cx count number of values that push in stack;
	mov ax,[input];
	loop1:
		div bx;for getting remainder and quotient
		push dx; push remainder in stack
		add cx,1;cunt value that push into stack
		mov dx,0;
		cmp cx,4;
		jb loop1;
	push si;
	ret
main:
	
	call decimalToHex
	call clearScreen
	
	call DisplayCharacter
	
 mov ax, 0x4c00 ; terminate program
 int 0x21 
 input: dw 29530;
 x: dw 20;
 y: dw 40;