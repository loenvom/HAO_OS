; 画出一条水平线
; 第一个参数表示行数
; 第二、三个参数表示列号的起始、结束位置
; 第四个参数表示用于画线的颜色
horizon_line_row dw 0
horizon_line_col dw 0, 0
horizon_line_color db 0                                                                                          
horizon_line:
    push bx
    push ax
    mov ax, [ds:horizon_line_row]
    imul ax, 320
    mov bx, [ds:horizon_line_col]
horizon_line_loop:
    cmp bx, [ds:horizon_line_col+2]
    ja horizon_line_exit
    push bx
    add bx, ax
    push ax
    mov al, [ds:horizon_line_color]
    mov byte [es:bx], al
    pop ax 
    pop bx
    inc bx
    jmp horizon_line_loop

horizon_line_exit:
    pop ax
    pop bx

    ret

; 画一条竖线
; 第一个参数表示列数
; 第二、三个参数表示行号的起始、结束位置
; 第四个参数表示颜色
; 需要注意的是 这里我画出的矩形是实心的
vertical_line_col: dw 0
vertical_line_row: dw 0, 0
vertical_line_color: db 0
vertical_line:

    push bx
    push ax
    mov bx, [ds:vertical_line_row]
    mov al, [ds:vertical_line_color]
vertical_line_loop:
    cmp bx, [ds:vertical_line_row+2]
    ja vertical_line_exit

    push bx
    imul bx, 320
    add bx, [ds:vertical_line_col]
    mov [es:bx], al    
    pop bx
    inc bx
    jmp vertical_line_loop

vertical_line_exit:
    pop ax
    pop bx

    ret

; 画实心矩阵
; 参数为开始和结束时的行数
rect_row: dw 0, 0
; 参数为开始和结束的列数
rect_col: dw 0, 0
; 填充所用的颜色
rect_color: db 0
rect:

    push bx
    mov bx, [ds:rect_col]
    mov [ds:horizon_line_col], bx
    mov bx, [ds:rect_col+2]
    mov [ds:horizon_line_col+2], bx
    mov bl, [ds:rect_color]
    mov [ds:horizon_line_color], bl
    mov bx, [ds:rect_row]
rect_loop:
    cmp bx, [ds:rect_row+2]
    ja rect_exit
    mov [ds:horizon_line_row], bx
    call horizon_line
    inc bx
    jmp rect_loop
rect_exit:
    pop bx

    ret

; 第一、二参数表示行数范围
; 第三、四参数表示列数范围
; 第五参数表示颜色
frame_row: dw 0, 0
frame_col: dw 0, 0
frame_color: db 0
frame:

    push ax

    mov al, [ds:frame_color]
    mov [ds:horizon_line_color], al
    mov [ds:vertical_line_color], al
    ; 先画出上下两行
    
    mov ax, [ds:frame_col]
    mov [ds:horizon_line_col], ax
    mov ax, [ds:frame_col+2]
    mov [ds:horizon_line_col+2], ax
    
    mov ax, [ds:frame_row]
    mov [ds:horizon_line_row], ax
    call horizon_line

    mov ax, [ds:frame_row+2]
    mov [ds:horizon_line_row], ax
    call horizon_line

    mov ax, [ds:frame_row]
    mov [ds:vertical_line_row], ax
    mov ax, [ds:frame_row+2]
    mov [ds:vertical_line_row+2], ax

    mov ax, [ds:frame_col]
    mov [ds:vertical_line_col], ax
    call vertical_line

    mov ax, [ds:frame_col+2]
    mov [ds:vertical_line_col], ax
    call vertical_line

    pop ax

    ret
