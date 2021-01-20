org 0x8400

jmp start

;封装的打印函数
;第一个参数行位置
;第二个参数列位置
;第三个参数打印图像的偏移地址
;第四个参数表示颜色
%include 'draw_font.asm' 
;大写字母文件
%include 'font_cap.asm'
;小写字母文件
%include 'font.asm'
;数字文件
%include 'digit.asm'
;字母表，在这里完成了对于数据的初始化
%include 'font_table.asm'
;封装了画图API
%include 'geolib.asm'
;UI API封装，主要是界面的布局
%include 'ui.asm'
; 处理键盘中断
%include 'key_solver.asm'

; 处理时间中断
%include 'time_solver.asm'

; 图片数据区
%include 'boy.asm'

; 播放音乐 这个模块有点问题 
; 调了一个下午我也没有调明白 这个音乐到底是放的什么
; 频率和节拍都没啥问题 
%include 'music.asm'
; 游戏处理板块
%include 'game.asm'
; 游戏中的人物角色信息
%include 'role.asm'
; 游戏中的墙数据
%include 'wall.asm'
; 游戏中的水果数据
%include 'fruit.asm'

; 存储的字符串，字符编码在 font_table 中可以查询
str_EditText:
dw 112, 30, 68, 60, 82, 28, 38, 60, 0
str_Picture:
dw 104, 38, 26, 60, 62, 56, 30, 58, 0
str_Game:
dw 86, 22, 46, 30, 0
str_Music:
dw 98, 62, 58, 38, 26, 0
str_Score:
dw 110, 26, 50, 56, 30, 0
; 预存的图片信息
pics:
dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
start:
    cli
    ;存储位置的初始化
    mov ax, 0
    mov ds, ax
    ;显存位置的初始化
    mov ax, 0xa000
    mov es, ax

    ;设置 320 * 200 256 色的显示模式
    mov ah, 00h
    mov al, 13h
    int 10h

    ;初始图片资源
    call InitPics

    ;完成对于字符表的初始化
    call init_font_table

    ;对于主界面的初始化
    call init_layout

    ; 人物信息的初始化
    call init_figure_table
    
    ; 完成 UI 界面中的布局，文字内容
    mov word [ds:put_words_pos], 27
    mov word [ds:put_words_pos+2], 20
    mov word [ds:put_words_start], str_EditText
    mov byte [ds:put_words_color], 0x0f
    call put_words
    
    mov word [ds:put_words_pos], 67
    mov word [ds:put_words_pos+2], 20
    mov word [ds:put_words_start], str_Picture
    mov byte [ds:put_words_color], 0x0f
    call put_words

    mov word [ds:put_words_pos], 107
    mov word [ds:put_words_pos+2], 20
    mov word [ds:put_words_start], str_Game
    mov byte [ds:put_words_color], 0x0f
    call put_words

    mov word [ds:put_words_pos], 147
    mov word [ds:put_words_pos+2], 20
    mov word [ds:put_words_start], str_Music
    mov byte [ds:put_words_color], 0x0f
    call put_words

    mov word [ds:0x24], key_solver
    mov word [ds:0x26], 0

    mov word [ds:0x20], time_solver
    mov word [ds:0x22], 0

    sti
    jmp $


InitPics:
    mov word [ds:pics+0], boy_0_data
    mov word [ds:pics+2], boy_1_data
    mov word [ds:pics+4], boy_2_data
    mov word [ds:pics+6], boy_3_data
    mov word [ds:pics+8], boy_4_data
    mov word [ds:pics+10], boy_5_data
    mov word [ds:pics+12], boy_6_data
    mov word [ds:pics+14], boy_7_data
    mov word [ds:pics+16], boy_8_data
    mov word [ds:pics+18], boy_9_data
    mov word [ds:pics+20], boy_10_data
    mov word [ds:pics+22], boy_11_data
    mov word [ds:pics+24], boy_12_data
    mov word [ds:pics+26], boy_13_data
    mov word [ds:pics+28], boy_14_data
    mov word [ds:pics+30], boy_15_data
    mov word [ds:pics+32], boy_16_data
    mov word [ds:pics+34], boy_17_data
    mov word [ds:pics+36], boy_18_data
    mov word [ds:pics+38], boy_19_data
    mov word [ds:pics+40], boy_20_data
    mov word [ds:pics+42], boy_21_data
    mov word [ds:pics+44], boy_22_data
    mov word [ds:pics+46], boy_23_data
    mov word [ds:pics+48], boy_24_data
    mov word [ds:pics+50], boy_25_data


    ret


