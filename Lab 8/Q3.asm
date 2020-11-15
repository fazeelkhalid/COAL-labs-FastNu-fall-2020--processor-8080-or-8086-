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
	nextchar1: 
	mov word [es:di], 0x0720 ; print space on screen
	add di, 2; move at next screen location
	cmp di, 4000 ; check is all screen cleared?
	jne nextchar1; if all screen not cleared then jump;
	;pop ax,es,di value from stack
	pop di;
	pop es;
	pop di;
ret

strlen:; store result in bx
	; push si in stack
	push si;
	mov si, string
	mov bx,-1;count string size;
	NullNotFind:
	add bx,1;
	cmp byte[si+bx],0X00;
	jne NullNotFind
	pop si
ret

totalOccurance:;cx store total occurance of given key
	call strlen; return length of string by bx
	jmp start
	found: ; is key found add 1 in cx
		add cx, 1;
		jmp insideNextChar;
	
	start:
	mov si,string;
	mov cx, 0;

	nextchar:
		mov dl,[key];
		cmp byte[si],dl
		je found;
		insideNextChar:
		add si, 1;
		sub bx, 1;store processed letter
		cmp bx, 0;
		jne nextchar;	
ret
pushNumber:
	pop si;store ip value
	mov ax,cx;
	mov cx, 0; count numbers that push in stack
	mov dx,0;reset dx;
	mov bx,10;
	nextNumber:
		add cx,1;
		div bx
		add dx,0x30;
		mov dh,0x07
		push dx;
		mov dx,0;
		cmp ax,0;
	jne nextNumber;
	
	push cx;
	push si;
ret	
	
displayNumber:
	call clearScreen;
	pop si; store ip value
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 556 ; point di to top left column
	pop cx; store total number that pushh in stack
	nextpop:
		pop dx; pop number from stack
		mov word [es:di], dx ; print number;
		add di,2;
		sub cx,1;
		cmp cx,0;
	jne nextpop;
	push si;
ret
	
main:
	call totalOccurance
	call pushNumber	
	call displayNumber
	
mov ax, 0x4c00 ; terminate program
int 0x21 

string:db 'Fzaaaaaasdddsddddefefafafaglgaafadsasaas aaasadkfaaaahaaaaaalaaaaiaaaaadaa aaaaaaaaaaa:a)',0
key: db ' ';