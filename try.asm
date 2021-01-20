

voice_data:

dw 262,294,330,262,262,294,330,262      
dw 330,349,392,330,349,392,392,440
dw 392,349,330,262,392,440,392,349
dw 330,262,294,196,262,294,196,262, 0

voice_time:

dw 16,16,16,16,16,16,16,16,16,16   
dw 32,16,16,32,8,8,8,8,16,16
dw 8,8,8,8,16,16,16,16,32,16,16,32, 0


voice_index: dw 0

open_voice:
	push ax
	in al, 61h
	or al, 00000010b
	out 61h, al
	pop ax	
	ret

close_voice:
	push ax
	in al, 61h
	and al, 11111101b
	out 61h, al
	pop ax
	ret	

MyDelay:

    push ax
    mov ax, 20
MyDelay_loop:
    cmp ax, 0
    je MyDelay_exit
    dec ax
    jmp MyDelay_loop
MyDelay_exit:
    pop ax
    ret

play_voice_data: dw 3400
play_voice_delay: dw 0
play_voice:
	push ax
	push dx
	push di
	
	mov al, 0b6h
	out 43h, al

	mov di, [ds:play_voice_data]

	mov    dx,12H
	mov    ax,34DEH
	div    di  

	out 42h, al
	mov al, ah
	out 42h, al	
	call open_voice
    mov ax, [ds:play_voice_delay]
    imul ax, 1000
play_voice_loop:
    cmp ax, 0
    je play_voice_exit
    call MyDelay
    dec ax
    jmp play_voice_loop
play_voice_exit:
    call close_voice
	pop di
	pop dx
	pop ax	 	
	ret




    mov bx, 0

    cmp word [ds:bx + voice_data], 0
    je exit
    mov ax, [ds:bx + voice_data]
    mov [ds:play_voice_data], ax
    mov ax, [ds:bx + voice_time]
    mov [ds:play_voice_delay], ax
    call play_voice
    add bx, 2
    jmp start_loop



	