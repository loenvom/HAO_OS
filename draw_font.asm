; 打印像素点的偏移位置
draw_font_pos:
dw 0, 0
; 像素点的数据区
draw_font_content:
dw 0
; 打印时所用的颜色
draw_font_color:
db 0
draw_font:

    push bx
    push ax
    mov ax, [ds:draw_font_pos]
    mov [ds:rect_row], ax
    add ax, 7
    mov [ds:rect_row+2], ax
    mov ax, [ds:draw_font_pos+2]
    mov [ds:rect_col], ax
    add ax, 6
    mov [ds:rect_col+2], ax
    mov byte [ds:rect_color], 0
    call rect
    
    mov bx, [ds:draw_font_content]
    mov ax, [ds:draw_font_pos]
    imul ax, 320
    add ax, [ds:draw_font_pos+2]
draw_font_loop:

    cmp word [ds:bx], 0
    je draw_font_exit
    push bx
    mov bx, [ds:bx]
    dec bx
    add bx, ax
    push ax
    mov al, [ds:draw_font_color]
    mov byte [es:bx], al
    pop ax
    pop bx
    add bx, 2
    jmp draw_font_loop
draw_font_exit:
    pop ax
    pop bx
    ret

;一次完整的调用打印字符函数的示例
;mov word [ds:draw_font_pos], 0
;mov word [ds:draw_font_pos+2], 0
;mov ax, [ds:font_table]
;mov word [ds:draw_font_content], ax
;call draw_font


;用以打印一句完整的语句
put_words_pos: dw 0, 0
put_words_start: dw 0
put_words_color: db 0

put_words:
    push cx
    push bx 
    push ax
    mov al, [ds:put_words_color]
    mov [ds:draw_font_color], al
    
    mov bx, [ds:put_words_pos]
    mov [ds:draw_font_pos], bx

    mov cx, [ds:put_words_pos+2]
    mov bx, [ds:put_words_start]
put_words_loop:
    cmp word [ds:bx], 0
    je put_words_exit
    push bx
    mov bx, [ds:bx]
    mov ax, [ds:bx + font_table - 2]
    pop bx
    mov [ds:draw_font_content], ax
    mov [ds:draw_font_pos+2], cx
    call draw_font
    add bx, 2
    add cx, 6
    jmp put_words_loop

put_words_exit:
    pop ax
    pop bx
    pop cx
    ret
