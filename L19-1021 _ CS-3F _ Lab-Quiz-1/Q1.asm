[org 0x0100]
;ax = [inputStartingBit];
; ch = remainder;
;cl = Quotient
; dh = count moving byte in ax
; dl = getting element of perticular block at perticular index
; bl = use to getting required bit
jmp main;
isZero:; if input number is zero then
	sub di,1;
	jmp innnerL4
L4: ; correct remainder if user input value less then 8
	cmp byte [inputStartingBit],0;
	je isZero;
	innnerL4: 
		mov ch,[inputStartingBit];
		jmp L3;
Li:
mov bh, 8; // divider
mov ax,[inputStartingBit];
div bh;
mov ch, ah; copy remainder
mov cl,al; copy Quotient
mov ax, 0; reset ax
mov si , array;
mov  dh, 0;
mov di,si;
cmp byte [inputStartingBit],8;if input number is less then 8
jbe L4;
cmp ch, 0;
jne l1; check if Byte is a multiple of 8 then start counting from 0
mov dh,1;
jmp l1
MoveNext:; if user enter bit number that multiple of 8 then
	add di,1;
	mov dl,[di];
	jmp skip;
l1:; use to poin di to that perticular byte sector
	add di,1;
	add dh,1;
	cmp dh,cl;
	jne l1
L3: ; input number is less then 8
mov dl,[di];
cmp ch, 0;
je MoveNext
mov bl, ch; move Quotient in bl for rotate left for getting required bit
GettingRequiredElementofBlock:
	rol dl,1;
	sub bl,1;
	cmp bl,0;
	jne GettingRequiredElementofBlock;
	mov bl, ch,
NowRemove:; Remove Unnecessary bit From left side
	clc
	shr dl,1;
	sub bl,1;
	cmp bl,0;
	jne NowRemove
; now acces next remaining bits from next Bytes
mov bl,ch; // tell how many bytes we should need to take from next Byte or element
cmp byte [inputStartingBit],248; // if last Byte comes
jae skip
mov dh,[di+1];
nextbitFormNextByte:
	sal dh,1;
	rcl dl,1
	cmp bl,0; if bl = 0 just jump on skip
	je skip
	sub bl,1
	cmp bl,0
	jne nextbitFormNextByte
skip:
	mov al,dl;
ret
main:
	call Li;
mov ax, 0x4C00
int 21h
array : db 1,2,172,154,54,36,127,28,49,140,121,112,123,104,185,166,174,183,196,207,218,225,234,243,215,216,227,208,209,30,31,172;
inputStartingBit: dw 248;
;00000001,00000010,10101100,10011010,00110110,00100100,01111111,00011100,49= 00110001....31= 00011111,172 = 10101100,
