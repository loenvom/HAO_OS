; 现在正在的功能
func_active: db 0
; 上一次的功能，用于场景的初始化
last_active: db 0
time_solver:

    push dx
    push bx
    push ax

    ; 覆盖上一次的选中框
    mov ah, 0
    mov al, [ds:func_active]
    mov [ds:last_active], al
    imul ax, 40

    mov word [ds:frame_col], 10
    mov word [ds:frame_col+2], 111
    add ax, 20
    mov [ds:frame_row], ax
    add ax, 20
    mov [ds:frame_row+2], ax
    mov byte [ds:frame_color], 0x0f
    call frame


    ; 暴力判断三种功能的情况
    cmp byte [ds:func_active], 0
    je time_solver_TextEdit

    cmp byte [ds:func_active], 1
    je time_solver_Picture

    cmp byte [ds:func_active], 2
    je time_solver_Game

time_solver_Game:
    call Game_handler
    jmp MayNextFunc


time_solver_Picture:
    call Picture_handler
    jmp MayNextFunc

    
time_solver_TextEdit:    
    call TextEdit_handler
    jmp MayNextFunc

MayNextFunc:

    cmp byte [ds:key_state_down], 0
    je MayPreFunc
    mov byte [ds:key_state_down], 0
    call nextFunc
    
MayPreFunc:

    cmp byte [ds:key_state_up], 0
    je time_solver_exit
    mov byte [ds:key_state_up], 0
    call preFunc


time_solver_exit:

    ; 音乐播放入口
    call MayPlayMusic
    mov al, [ds:func_active]
    cmp al, [ds:last_active]
    je time_solver_exit_next
    
    ; 区域的刷新

    call ResetRightZone
    call ResetScoreZone

    cmp al, 2
    je time_solver_init_canvas

    cmp al, 0
    je time_solver_init_EditText 

    jmp time_solver_exit_next

time_solver_init_canvas:
    call InitCanvas
    jmp time_solver_exit_next

time_solver_init_EditText:
    call InitEditText
    jmp time_solver_exit_next
time_solver_exit_next:    
    mov ah, 0
    mov al, [ds:func_active]
    imul ax, 40

    mov word [ds:frame_col], 10
    mov word [ds:frame_col+2], 111
    add ax, 20
    mov [ds:frame_row], ax
    add ax, 20
    mov [ds:frame_row+2], ax
    mov byte [ds:frame_color], 0x0e
    call frame

    mov al, 0x20
    mov dx, 0x20
    out dx, al
    pop ax
    pop bx
    pop dx
    iret

; 刷新功能能显示区域
ResetRightZone:

    mov word [ds:rect_row], 2
    mov word [ds:rect_row+2], 197
    mov word [ds:rect_col], 123
    mov word [ds:rect_col+2], 317
    mov byte [ds:rect_color], 0
    call rect

    ret

; 处理换行的问题，很多的位置数据都是直接写死的，比较方便
; 但是并不符合开发标准
reset_index:

    push ax

    mov ax, [ds:index_pos+2]
    add ax, 6
    mov [ds:index_pos+2], ax
    cmp ax, 300
    jb reset_index_exit
    mov ax, [ds:index_pos]
    add ax, 8
    mov [ds:index_pos], ax
    mov word [ds:index_pos+2], 135

reset_index_exit:
    pop ax

    ret
; 光标左移
left_index:

    push ax
    mov ax, [ds:index_pos+2]
    cmp ax, 135
    je left_index_left
    sub ax, 6
    mov [ds:index_pos+2], ax
    jmp left_index_exit
;输入指针位于最左边的特殊情况
left_index_left:

    mov ax, [ds:index_pos]
    cmp ax, 10
    je left_index_exit

    sub ax, 8
    mov [ds:index_pos], ax
    mov word [ds:index_pos+2], 297


left_index_exit:
    pop ax

    ret

; 文本编辑器的相关功能
index_pos: dw 10, 135

TextEdit_handler:
    push dx
    push bx
    push ax

    mov bx, 0
    ; 打印数字
TextEdit_handler_print_digit_loop:
    cmp bx, 10
    je TextEdit_handler_print_digit_exit
    cmp byte [ds:key_state_digit+bx], 0
    je TextEdit_handler_print_digit_continue
    mov byte [ds:key_state_digit+bx], 0
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov byte [ds:draw_font_color], 0x09
    push bx
    imul bx, 2
    mov ax, [ds:font_table + bx]
    mov word [ds:draw_font_content], ax
    pop bx
    call draw_font
    call reset_index
TextEdit_handler_print_digit_continue:
    inc bx
    jmp TextEdit_handler_print_digit_loop

TextEdit_handler_print_digit_exit:
    
    cmp byte [ds:now_caps], 1
    je TextEdit_handler_print_caps_alpha

    cmp byte [ds:key_state_shift], 1
    je TextEdit_handler_print_caps_alpha

    mov bx, 0

    ; 打印小写字母
TextEdit_handler_print_sma_alpha_loop:
    cmp bx, 26
    je TextEdit_handler_print_space
    cmp byte [ds:key_state_alpha+bx], 0
    je TextEdit_handler_print_sma_alpha_continue
    mov byte [ds:key_state_alpha+bx], 0
    push bx
    imul bx, 2
    add bx, 20
    mov ax, [ds:font_table+bx]
    pop bx
    mov [ds:draw_font_content], ax
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov byte [ds:draw_font_color], 0x04
    call draw_font
    call reset_index
TextEdit_handler_print_sma_alpha_continue:
    inc bx
    jmp TextEdit_handler_print_sma_alpha_loop

TextEdit_handler_print_caps_alpha:
    mov bx, 0
    ; 打印大写字母
TextEdit_handler_print_caps_alpha_loop:
    cmp bx, 26
    je TextEdit_handler_print_space
    cmp byte [ds:key_state_alpha+bx], 0
    je TextEdit_handler_print_caps_alpha_continue
    mov byte [ds:key_state_alpha+bx], 0
    push bx
    imul bx, 2
    add bx, 72
    mov ax, [ds:font_table+bx]
    pop bx
    mov [ds:draw_font_content], ax
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov byte [ds:draw_font_color], 0x04
    call draw_font
    call reset_index
TextEdit_handler_print_caps_alpha_continue:
    inc bx
    jmp TextEdit_handler_print_caps_alpha_loop

    ; 判断空格
TextEdit_handler_print_space:

    cmp byte [ds:key_state_space], 0
    je TextEdit_handler_print_enter
    mov byte [ds:key_state_space], 0
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov word [ds:draw_font_content], font_space
    call draw_font
    call reset_index 
    ; 判断是否需要换行
TextEdit_handler_print_enter:
    
    cmp byte [ds:key_state_enter], 0
    je TextEdit_handler_print_back
    mov byte [ds:key_state_enter], 0
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov word [ds:draw_font_content], font_space
    call draw_font
    mov ax, [ds:index_pos]
    add ax, 8
    mov [ds:index_pos], ax
    mov word [ds:index_pos+2], 135

    ; 退位处理
TextEdit_handler_print_back:

    cmp byte [ds:key_state_back], 0
    je TextEdit_handler_exit
    mov byte [ds:key_state_back], 0
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov word [ds:draw_font_content], font_space
    call draw_font
    call left_index
    mov ax, [ds:index_pos]
    mov [ds:draw_font_pos], ax
    mov ax, [ds:index_pos+2]
    mov [ds:draw_font_pos+2], ax
    mov word [ds:draw_font_content], font_space
    call draw_font

TextEdit_handler_exit:
    mov ax, [ds:index_pos+2]
    mov [ds:vertical_line_col], ax
    mov ax, [ds:index_pos]
    mov [ds:vertical_line_row], ax
    add ax, 7
    mov [ds:vertical_line_row+2], ax
    mov byte [ds:vertical_line_color], 0x0f
    call vertical_line
    pop ax
    pop bx
    pop dx
    ret

; 活动的切换
nextFunc:
    push ax
    
    mov al, [ds:func_active]
    inc al
    cmp al, 3
    jnz nextFunc_exit
    mov al, 0
nextFunc_exit:   
    mov [ds:func_active], al
    pop ax
    ret

preFunc:
    push ax
    mov al, [ds:func_active]
    inc al
    dec al
    cmp al, 0
    jnz preFunc_exit
    mov al, 3
preFunc_exit:
    dec al
    mov [ds:func_active], al
    pop ax
    ret


; 图片播放处理，就是一个轮播图
pic_index: dw 0
pic_time: dw 0

Picture_handler:
    push bx
    push ax
    mov ax, [ds:pic_time]
    inc ax
    mov [ds:pic_time], ax
    cmp ax, 100
    jbe Picture_handler_show
    call nextPicIndex
Picture_handler_show:
    mov bx, [ds:pic_index]
    mov ax, [ds:bx + pics]
    mov [ds:draw_font_content], ax
    mov word [ds:draw_font_pos], 60
    mov word [ds:draw_font_pos+2], 170
    mov byte [ds:draw_font_color], 0x0a
    call draw_font
    pop ax
    pop bx
    ret

nextPicIndex:
    call ResetRightZone
    push ax
    mov word [ds:pic_time], 0
    mov ax, [ds:pic_index]
    add ax, 2
    cmp ax, 50
    jnz nextPicIndex_exit
    mov ax, 0
nextPicIndex_exit:
    mov [ds:pic_index], ax
    pop ax
    ret


    
; 初始化游戏中的地图数据
InitCanvas:

    push bx
    push ax
    mov word [ds:put_words_start], str_Score
    mov word [ds:put_words_pos], 180
    mov word [ds:put_words_pos+2], 20
    mov byte [ds:put_words_color], 0x0f
    mov word [ds:horizon_line_row], 190
    mov word [ds:horizon_line_col], 10
    mov word [ds:horizon_line_col+2], 111
    mov byte [ds:horizon_line_color], 0x09
    call horizon_line
    call put_words
    mov word [ds:Game_score], 0
    mov word [ds:role_pos], 0
    mov word [ds:role_pos+2], 0
    mov bx, 0

InitCanvas_loop:
    cmp bx, 200
    je InitCanvas_exit
    mov ax, [ds:bx + st_canvas]
    mov [ds:bx + canvas], ax
    add bx, 2
    jmp InitCanvas_loop 
InitCanvas_exit:
    pop ax
    pop bx
    ret


InitEditText:

    mov word [ds:index_pos], 10
    mov word [ds:index_pos+2], 135

    ret

ResetScoreZone:

    mov word [ds:rect_row], 180
    mov word [ds:rect_row+2], 190
    mov word [ds:rect_col], 10
    mov word [ds:rect_col+2], 111

    mov byte [ds:rect_color], 0

    call rect

    ret
