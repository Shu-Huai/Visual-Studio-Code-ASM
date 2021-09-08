Data segment
	mess db 'Your Hex number is:$'
	bb   db 00110100b, 00010010b
Data ends
Prognam segment
	        assume cs: prognam, ds:data
	start:  mov    ax, data
	        mov    ds,ax
	        lea    dx, mess
	        mov    ah,9
	        int    21h
	        mov    bx, word ptr bb
	        mov    Ch,4                	;四个16进制数位，循环4次
	rotate: mov    cl,4                	;
	        rol    bx, cl              	;右移四位
	        mov    al, bl
	        and    al, 0fh             	;取低4位
	        add    al,30h              	;将16进制转为ASCII码
	        cmp    al,3ah              	; 比较，>9？
	        JL     printit             	;  是0到9的数码，打印
	        Add    al,7h               	; 是A 到F，转换
	Printit:
	        mov    dl, al              	; ASCII码放DL
	        mov    ah, 2               	; 显示功能
	        int    21h                 	;Call DOS
	        dec    ch
	        jnz    rotate              	;是4个数位吗？如还不是，继续
	        mov    ah,4ch
	        int    21h                 	;return to DOS
prognam ends       ; end of segment
end   start                     ; end of assembly