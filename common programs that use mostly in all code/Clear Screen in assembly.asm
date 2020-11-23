[org 0x0100]
jmp main
clearScreen:
	push ax
	push si
	push es
	push cx
	
	mov ax,0xb800
	mov es,ax
	
	mov ax,0x0720;
	mov cx,2000;
	mov di,0
	
	cld
	rep stosw;
	
	pop cx
	pop es;
	pop si;
	pop ax;
	
ret;
	
main:
	call clearScreen;



mov ax, 0x4c00 ; terminate program
int 0x21