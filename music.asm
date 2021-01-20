; 整个作品中最差的一个板块
; 总觉得整个调用方式是不全面的

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

voice_delay: dw 0

; 开启声音
open_voice:
	push ax
	in al, 61h
	or al, 0x03
	out 61h, al
	pop ax	
	ret

; 关闭声音
close_voice:
	push ax
	in al, 61h
	and al, 11111101B
	out 61h, al
	pop ax
	ret	

play_voice_data: dw 0

; 播放声音
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

	pop di
	pop dx
	pop ax	 	
	ret

Music_on: dw 0

; 通过定时器的计数完成延时操作
Music_handler:

	push bx
	push ax

	cmp word [ds:voice_delay], 0
	je Music_handler_next
	mov ax, [ds:voice_delay]
	dec ax
	mov [ds:voice_delay], ax
	jmp Music_handler_exit

Music_handler_next:
	
	call close_voice
    mov bx, [ds:voice_index]
    mov ax, [ds:bx + voice_data]
    mov [ds:play_voice_data], ax
    mov ax, [ds:bx + voice_time]
    mov [ds:voice_delay], ax
    call play_voice
    add bx, 2
	mov [ds:voice_index], bx
    cmp word [ds:bx + voice_data], 0
	jnz Music_handler_exit
	mov word [ds:voice_index], 0
Music_handler_exit:
	pop ax
	pop bx
	ret

; 尝试播放音乐
MayPlayMusic:
	cmp word [ds:Music_on], 0
	je NotPlayMusic

	cmp word [ds:Music_on], 1
	je PlayMusic

NotPlayMusic:
	mov word [ds:frame_row], 140
	mov word [ds:frame_row+2], 160
	mov word [ds:frame_col], 10
	mov word [ds:frame_col+2], 111
	mov byte [ds:frame_color], 0x0f
	call frame
	; 强制关闭声音 但是和预想的结果不太一样
	call close_voice
	mov word [ds:voice_delay], 1
	mov word [ds:voice_index], 0
	jmp MayPlayMusic_exit

PlayMusic:
	mov word [ds:frame_row], 140
	mov word [ds:frame_row+2], 160
	mov word [ds:frame_col], 10
	mov word [ds:frame_col+2], 111
	mov byte [ds:frame_color], 0x0c
	call frame
	call Music_handler
	jmp MayPlayMusic_exit
	

MayPlayMusic_exit:

	ret


	