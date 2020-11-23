[org 0x0100]
jmp main
strlen:
	push di
	push cx
	
	mov ax,0;
	mov cx,0xffff; store max value in cx
	mov di,string;
	
	cld;
	repne scasb;
	
	mov ax,0xffff;
	sub ax,cx;
	pop cx;
	pop di;
ret;
main:
	call strlen; find string length and return it in ;;;;;ax;;;;;
mov ax, 0x4c00 ; terminate program
int 0x21

string: db "fazeelKhalid",0; NULL terminated string