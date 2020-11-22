[org 0x0100]
jmp main
checkfirstNumber: ; check is first number is zero or not
	add bx,2;
	cmp word[si+bx],0
	je checkfirstNumber;
cmp bx,8;
je tempExit
jmp normalExe1;

checkSecondNumber:;check is second number is zero or not
	add dx,1;
	add bx, 2
	cmp word[bx],0
	je checkSecondNumber;
cmp dx,2;
je Exit;
jmp normalExe2
tempExit:
	jmp Exit;

shiftRight:; shift second number right
	shr word[bx+2],1;
	rcr word[bx],1;
	jmp insideAddNumber
shiftLeft:; shif first number left
	shl word [si], 1
	rcl word [si+2], 1
	rcl word [si+4], 1
	rcl word [si+6], 1
	jmp insideSkip;
addNumber:
		jmp shiftRight
		insideAddNumber:
		jnc  skip
		mov ax, [si]
		add [di], ax
		mov ax, [si+2]
		adc [di+2], ax
		mov ax, [si+4]
		adc [di+4], ax
		mov ax, [si+6]
		adc [di+6], ax
		jmp insideMultiply;
Multiply:
	push num1
	push num2
	push bp
	mov bp, sp
	mov di, [bp+8]
	mov si, [bp+2]; point si->num2
	mov bx, si ; moves 2st 32-bit number in ebx register
	mov si, [bp+4] ; point si->num1
	mov cx , bx; hold bx value for a short time
	mov dx ,0; use to see second number is zero
	sub cx, 2;
	jmp checkfirstNumber; // check is first number equal to zero;
	normalExe1: ; start normal execution after checking first number
	mov bx,cx; restore bx value now cx is free
	jmp checkSecondNumber;  check is first number equal to zero;
	normalExe2:;start normal execution after checking second number
	add cx,2;
	mov bx,cx;
	jmp addNumber;
	insideMultiply:
	skip:
		sub byte [count] , 1;
		jmp shiftLeft
		insideSkip:
		cmp byte[count],0;
		jnz addNumber
	Exit:
	;Now free stack
	pop bp
	pop ax
	pop ax
ret
main:
	push result
	call Multiply

mov ax, 0x4c00
int 0x21
;data
num1:dd 0xDEADBEEF,0
num2:dd 0xDEADBEEF,0
result:dd 0,0
count:db 32