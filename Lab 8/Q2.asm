; hello world printing using string instructions
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

search:
	;di store array starting index
	;bl store key
	;cl use to store array size
	;al indicate key found or not
	mov cl,[sizeOfArray];
	mov bl,[key];
	mov di,array;
	jmp loop1
	foundJump:
		mov al,1;
		ret
		jmp insideLoop1
	loop1:; check all element of array		
		cmp [di], bl; compare elemet of array wih key
		je foundJump;
		add di,1; getting next element of array
		insideLoop1:
		
		sub cl,1; subtract 1 from size
		cmp cl,0
		jne loop1;
		mov al,2; if key not found
ret



strlen: push bp
	 mov bp,sp
	 push es
	 push cx
	 push di
	 les di, [bp+4] ; point es:di to string
	 mov cx, 0xffff ; load maximum number in cx
	 xor al, al ; load a zero in al
	 repne scasb ; find zero in the string
	 mov ax, 0xffff ; load maximum number in ax
	 sub ax, cx ; find change in cx
	 dec ax ; exclude null from length
	 pop di
	 pop cx
	 pop es
	 pop bp
	 ret 4
; subroutine to print a string
; takes the x position, y position, attribute, and address of a null
; terminated string as parameters
printstr: 
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	push ds ; push segment of string
	mov ax, [bp+4]
	push ax ; push offset of string
	call strlen ; calculate string length 
	cmp ax, 0 ; is the string empty
	jz exit ; no printing if string is empty
	mov cx, ax ; save length in cx
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov al, 80 ; load al with columns per row
	mul byte [bp+8] ; multiply with y position
	add ax, [bp+10] ; add x position
	shl ax, 1 ; turn into byte offset
	mov di,ax ; point di to required location
	mov si, [bp+4] ; point si to string
	mov ah, [bp+6] ; load attribute in ah
	cld ; auto increment mode
	nextchar: lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop nextchar ; repeat for the whole string
	exit: pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
ret 8
 
isFound:
	;dh store property of char
	; si point message that we want to display
	mov ax, 35
	push ax ; push x position
	mov ax, 3
	push ax ; push y position
	mov ax,  0x82 ; blue on white attribute
	push ax ; push attribute
	mov ax, found
	push ax ; push address of message
	jmp insidemain
	
main:
	call clearScreen ; call the clearScreen subroutine
	mov ax, 0;reset ax
	call search;
	cmp ax,1;
	je isFound;
	
	mov ax, 35
	push ax ; push x position
	mov ax, 3
	push ax ; push y position
	mov ax, 0x04 ; green with blinking property
	push ax ; push attribute
	mov ax, failed
	push ax ; push address of message
	
	insidemain:

	call printstr ; call the printstr subroutine
 	
mov ax, 0x4c00 ; terminate program
int 0x21 

found:db 'FOUND :)',0
failed: db 'Failed :(',0
array: db 2,5,12,15,2,19,87,34,25;
sizeOfArray: db 9
key:db 3;