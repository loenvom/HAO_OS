; 游戏的逻辑处理代码
role_pos: dw 0, 0
role_figure: dw 0
; 游戏人物的动作表
figure_table: dw 0,0,0,0,0,0,0,0
; 手动初始化动作表
init_figure_table:
    mov word [ds:figure_table+0], role_0_data
    mov word [ds:figure_table+2], role_1_data
    mov word [ds:figure_table+4], role_2_data
    mov word [ds:figure_table+6], role_3_data
    mov word [ds:figure_table+8], role_4_data
    mov word [ds:figure_table+10], role_5_data
    mov word [ds:figure_table+12], role_6_data
    mov word [ds:figure_table+14], role_7_data
    ret

; 对于人物动画的刷新延迟
Game_delay: dw 0
; 对于游戏画面的刷新延迟
Game_freq: dw 0

Game_score: dw 0

; 游戏的整体逻辑处理函数
Game_handler:

    cmp word [ds:Game_freq], 0
    je Game_handler_entry
    push ax
    mov ax, [ds:Game_freq]
    dec ax
    mov [ds:Game_freq], ax
    pop ax
    ret
Game_handler_entry:
    ; 下面都这些很长的是对于框架的处理
    mov word [ds:Game_freq], 20
    mov word [ds:frame_row], 10
    mov word [ds:frame_row+2], 190
    mov word [ds:frame_col], 130
    mov word [ds:frame_col+2], 310
    mov byte [ds:frame_color], 0x0b
    call frame

    mov word [ds:frame_row], 11
    mov word [ds:frame_row+2], 189
    mov word [ds:frame_col], 131
    mov word [ds:frame_col+2], 309
    mov byte [ds:frame_color], 0x0b
    call frame

    mov word [ds:frame_row], 12
    mov word [ds:frame_row+2], 188
    mov word [ds:frame_col], 132
    mov word [ds:frame_col+2], 308
    mov byte [ds:frame_color], 0x0d
    call frame

    mov word [ds:frame_row], 13
    mov word [ds:frame_row+2], 187
    mov word [ds:frame_col], 133
    mov word [ds:frame_col+2], 307
    mov byte [ds:frame_color], 0x0d
    call frame

    mov word [ds:frame_row], 14
    mov word [ds:frame_row+2], 186
    mov word [ds:frame_col], 134
    mov word [ds:frame_col+2], 306
    mov byte [ds:frame_color], 0x0e
    call frame

    mov word [ds:frame_row], 15
    mov word [ds:frame_row+2], 185
    mov word [ds:frame_col], 135
    mov word [ds:frame_col+2], 305
    mov byte [ds:frame_color], 0x0e
    call frame

    ;画出游戏的地图
    call DrawCanvas

    ; 部分刷新, 移除上一次的人物移动痕迹
    call EraseRole

    ; 这里就是在暴力处理 人物的移动
    ; 具体的碰撞检测在之后的封装中
    cmp byte [ds:key_state_alpha + 0], 1
    je Game_handler_roleleft

    cmp byte [ds:key_state_alpha + 18], 1
    je Game_handler_roledown

    cmp byte [ds:key_state_alpha + 22], 1
    je Game_handler_roleup

    cmp byte [ds:key_state_alpha + 3], 1
    je Game_handler_roleright

    jmp Game_handler_exit

Game_handler_roledown:
    call Role_move_down
    mov byte [ds:key_state_alpha + 18], 0
    jmp Game_handler_exit

Game_handler_roleup:
    call Role_move_up
    mov byte [ds:key_state_alpha + 22], 0
    jmp Game_handler_exit

Game_handler_roleleft:
    call Role_move_left
    mov byte [ds:key_state_alpha + 0], 0
    jmp Game_handler_exit

Game_handler_roleright:
    call Role_move_right
    mov byte [ds:key_state_alpha + 3], 0
    jmp Game_handler_exit

Game_handler_exit:
    call DrawRole
    call RefreshScore
    ret

; 以人物向下移动给出解释
Role_move_down:
    ; 判断能否下移
    cmp word [ds:role_pos], 9
    jb Role_move_down_next
    ret
Role_move_down_next:
    push ax
    ; 改变人物朝向
    call SetDirDown

    mov ax, [ds:role_pos+2]
    mov [ds:CheckPos_pos+2], ax

    mov ax, [ds:role_pos]
    add ax, 1
    mov [ds:CheckPos_pos], ax
    
    ; 暴力判断三种情况
    call CheckPos
    cmp word [ds:CheckPos_result], 0
    je Role_move_down_space

    cmp word [ds:CheckPos_result], 1
    je Role_move_down_fruit

    cmp word [ds:CheckPos_result], 2
    je Role_move_down_exit

; 暴力手写的方向键判断
Role_move_down_space:
    mov [ds:role_pos], ax
    jmp Role_move_down_exit
Role_move_down_fruit:
    mov [ds:role_pos], ax
    call RemoveFruit
    jmp Role_move_down_exit
Role_move_down_exit:
    pop ax
    ret

SetDirDown:

    push ax
    mov ax, [ds:role_figure]
    and ax, 0110
    cmp ax, 2
    mov word [ds:role_figure], 2
    je SetDirDown_exit
SetDirDown_exit:
    pop ax
    ret


Role_move_up:
    cmp word [ds:role_pos], 0
    ja Role_move_up_next
    ret
Role_move_up_next:
    push ax
    ; 改变人物朝向
    call SetDirUp

    mov ax, [ds:role_pos+2]
    mov [ds:CheckPos_pos+2], ax

    mov ax, [ds:role_pos]
    sub ax, 1
    mov [ds:CheckPos_pos], ax
    
    ; 暴力判断三种情况
    call CheckPos
    cmp word [ds:CheckPos_result], 0
    je Role_move_up_space

    cmp word [ds:CheckPos_result], 1
    je Role_move_up_fruit

    cmp word [ds:CheckPos_result], 2
    je Role_move_up_exit

Role_move_up_space:
    mov [ds:role_pos], ax
    jmp Role_move_up_exit
Role_move_up_fruit:
    mov [ds:role_pos], ax
    call RemoveFruit
    jmp Role_move_up_exit
Role_move_up_exit:
    pop ax
    ret


SetDirUp:
    push ax
    mov ax, [ds:role_figure]
    and ax, 0110
    cmp ax, 6
    mov word [ds:role_figure], 6
    je SetDirUp_exit
SetDirUp_exit:
    pop ax
    ret

Role_move_left:
    cmp word [ds:role_pos+2], 0
    ja Role_move_left_next
    ret
Role_move_left_next:
    push ax
    ; 改变人物朝向
    call SetDirLeft

    mov ax, [ds:role_pos]
    mov [ds:CheckPos_pos], ax

    mov ax, [ds:role_pos+2]
    sub ax, 1
    mov [ds:CheckPos_pos+2], ax
    
    ; 暴力判断三种情况
    call CheckPos
    cmp word [ds:CheckPos_result], 0
    je Role_move_left_space

    cmp word [ds:CheckPos_result], 1
    je Role_move_left_fruit

    cmp word [ds:CheckPos_result], 2
    je Role_move_left_exit

Role_move_left_space:
    mov [ds:role_pos+2], ax
    jmp Role_move_left_exit
Role_move_left_fruit:
    mov [ds:role_pos+2], ax
    call RemoveFruit
    jmp Role_move_left_exit
Role_move_left_exit:
    pop ax
    ret

SetDirLeft:
    push ax
    mov ax, [ds:role_figure]
    and ax, 0110
    cmp ax, 4
    mov word [ds:role_figure], 4
    je SetDirLeft_exit
SetDirLeft_exit:
    pop ax
    ret


Role_move_right:
    cmp word [ds:role_pos+2], 9
    jb Role_move_right_next
    ret
Role_move_right_next:
    push ax
    ; 改变人物朝向
    call SetDirRight

    mov ax, [ds:role_pos]
    mov [ds:CheckPos_pos], ax

    mov ax, [ds:role_pos+2]
    add ax, 1
    mov [ds:CheckPos_pos+2], ax
    
    ; 暴力判断三种情况
    call CheckPos
    cmp word [ds:CheckPos_result], 0
    je Role_move_right_space

    cmp word [ds:CheckPos_result], 1
    je Role_move_right_fruit

    cmp word [ds:CheckPos_result], 2
    je Role_move_right_exit

Role_move_right_space:
    mov [ds:role_pos+2], ax
    jmp Role_move_right_exit
Role_move_right_fruit:
    mov [ds:role_pos+2], ax
    call RemoveFruit
    jmp Role_move_right_exit
Role_move_right_exit:
    pop ax
    ret

SetDirRight:
    push ax
    mov ax, [ds:role_figure]
    and ax, 0110
    cmp ax, 0
    mov word [ds:role_figure], 0
    je SetDirRight_exit
SetDirRight_exit:
    pop ax
    ret

; 绘制人物
DrawRole:
    push bx
    push ax
    mov ax, [ds:role_pos]
    imul ax, 16
    add ax, 20
    mov [ds:draw_font_pos], ax
    mov ax, [ds:role_pos+2]
    imul ax, 16
    add ax, 140
    mov [ds:draw_font_pos+2], ax
    mov byte [ds:draw_font_color], 0x0b
    mov bx, [ds:role_figure]
    ; 满足延时条件，改变人物贴图
    cmp word [ds:Game_delay], 0
    ja DrawRole_exit
    
    xor bx, 1
    mov [ds:role_figure], bx
    mov word [ds:Game_delay], 5
DrawRole_exit:  
    mov ax, [ds:Game_delay]
    dec ax
    mov [ds:Game_delay], ax
    imul bx, 2
    mov ax, [ds:bx + figure_table]
    mov [ds:draw_font_content], ax
    call draw_font
    pop ax
    pop bx
    ret

EraseRole:
    push ax

    mov ax, [ds:role_pos]
    imul ax, 16
    add ax, 20
    mov [ds:rect_row], ax
    add ax, 15
    mov [ds:rect_row+2], ax

    mov ax, [ds:role_pos+2]
    imul ax, 16
    add ax, 140
    mov [ds:rect_col], ax
    add ax, 15
    mov [ds:rect_col+2], ax

    mov byte [ds:rect_color], 0

    call rect
    pop ax
    ret


canvas:

dw 0,0,0,0,0,0,2,2,2,2,
dw 0,0,1,2,0,0,1,0,1,0,
dw 0,0,0,2,0,0,0,2,2,0,
dw 0,1,0,2,0,0,0,2,0,0,
dw 0,2,2,2,0,0,2,2,0,0,
dw 0,0,0,1,0,0,0,0,0,0,
dw 0,2,2,2,2,2,0,1,0,2,
dw 0,0,0,1,0,2,0,0,2,2,
dw 0,1,0,0,2,2,0,0,2,0,
dw 0,0,0,0,0,0,1,0,0,0,


st_canvas:

dw 0,0,0,0,0,0,2,2,2,2,
dw 0,0,1,2,0,0,1,0,1,0,
dw 0,0,0,2,0,0,0,2,2,0,
dw 0,1,0,2,0,0,0,2,0,0,
dw 0,2,2,2,0,0,2,2,0,0,
dw 0,0,0,1,0,0,0,0,0,0,
dw 0,2,2,2,2,2,0,1,0,2,
dw 0,0,0,1,0,2,0,0,2,2,
dw 0,1,0,0,2,2,0,0,2,0,
dw 0,0,0,0,0,0,1,0,0,0,

; 画出地图，涉及三级调用
DrawCanvas:

    push cx
    push bx
    push ax

    mov cx, 0
DrawCanvas_row_loop:
    cmp cx, 10
    je DrawCanvas_exit
    call DrawCanvas_col
    inc cx
    jmp DrawCanvas_row_loop

DrawCanvas_exit:

    pop ax
    pop bx
    pop cx

    ret


DrawCanvas_col:
    mov ax, 0
    
DrawCanvas_col_loop:   
    cmp ax, 10
    je DrawCanvas_col_exit
    push cx
    imul cx, 16
    add cx, 20
    mov [ds:draw_font_pos], cx
    pop cx
    push ax
    imul ax, 16
    add ax, 140
    mov [ds:draw_font_pos+2], ax
    pop ax
    mov bx, cx
    imul bx, 10
    add bx, ax
    imul bx, 2
    call DrawCanvas_item
    inc ax
    jmp DrawCanvas_col_loop
DrawCanvas_col_exit:
    ret

DrawCanvas_item:


    cmp word [ds:bx + canvas], 0
    je DrawCanvas_item_exit

    cmp word [ds:bx + canvas], 1
    je DrawCanvas_item_fruit

    cmp word [ds:bx + canvas], 2
    je DrawCanvas_item_wall


DrawCanvas_item_fruit:
    
    mov byte [ds:draw_font_color], 0x0c
    mov word [ds:draw_font_content], fruit_data
    call draw_font
    jmp DrawCanvas_item_exit

DrawCanvas_item_wall:
    
    mov byte [ds:draw_font_color], 0x0f
    mov word [ds:draw_font_content], wall_data
    call draw_font
    jmp DrawCanvas_item_exit

DrawCanvas_item_exit:
    ret


CheckPos_pos: dw 0, 0
CheckPos_result: dw 0
CheckPos:
    push bx
    push ax
    mov bx, [ds:CheckPos_pos]
    imul bx, 10
    add bx, [ds:CheckPos_pos+2]
    imul bx, 2
    mov ax, [ds:bx + canvas]
    mov [ds:CheckPos_result], ax
    pop ax
    pop bx  
    ret

; 吃掉了一个水果 
RemoveFruit:
    push bx
    push ax
    mov ax, [ds:Game_score]
    inc ax
    mov [ds:Game_score], ax
    mov bx, [ds:role_pos]
    imul bx, 10
    add bx, [ds:role_pos+2]
    imul bx, 2
    mov byte [ds:bx + canvas], 0
    pop ax
    pop bx
    ret
; 刷新成绩
RefreshScore:
    push bx
    push ax
    mov word [ds:rect_row], 180
    mov word [ds:rect_row+2], 189
    mov word [ds:rect_col], 55
    mov word [ds:rect_col+2], 65
    mov byte [ds:rect_color], 0
    call rect
    mov bx, [ds:Game_score]
    imul bx, 2
    mov ax, [ds:bx + font_table]
    mov [ds:draw_font_content], ax
    mov word [ds:draw_font_pos], 180
    mov word [ds:draw_font_pos+2], 55
    mov byte [ds:draw_font_color], 0x0c 
    call draw_font
    pop ax
    pop bx
    ret
