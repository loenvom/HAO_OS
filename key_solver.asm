;在本文件当中完成对于按键事件的判断
;用来判断当前各个字母键的情况 1 表示处于按下状态
key_state_alpha: 
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
db 0, 0, 0, 0, 0, 0,
;用来判断当前各个数字键的情况
key_state_digit:
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;用来表示shift键的情况
key_state_shift:
db 0
;用来表示caps的情况
key_state_caps:
db 0
;存储当前大小写的锁定情况
now_caps:
db 0
;用来表示当前的space的状况
key_state_space: db 0
key_state_enter: db 0
key_state_back: db 0
key_state_up: db 0
key_state_down: db 0
key_state_left: db 0
key_state_right: db 0

; 整体使用C++ 暴力写的 但是其实可以用数组 循环解决
key_solver:
    push bx
    push dx
    push ax
    mov dx, 0x60
    in al, dx

    cmp al, 11
    je keydown_0

    cmp al, 2
    je keydown_1

    cmp al, 3
    je keydown_2

    cmp al, 4
    je keydown_3

    cmp al, 5
    je keydown_4

    cmp al, 6
    je keydown_5

    cmp al, 7
    je keydown_6

    cmp al, 8
    je keydown_7

    cmp al, 9
    je keydown_8

    cmp al, 10
    je keydown_9

    cmp al, 30
    je keydown_a

    cmp al, 48
    je keydown_b

    cmp al, 46
    je keydown_c

    cmp al, 32
    je keydown_d

    cmp al, 18
    je keydown_e

    cmp al, 33
    je keydown_f

    cmp al, 34
    je keydown_g

    cmp al, 35
    je keydown_h

    cmp al, 23
    je keydown_i

    cmp al, 36
    je keydown_j

    cmp al, 37
    je keydown_k

    cmp al, 38
    je keydown_l

    cmp al, 50
    je keydown_m

    cmp al, 49
    je keydown_n

    cmp al, 24
    je keydown_o

    cmp al, 25
    je keydown_p

    cmp al, 16
    je keydown_q

    cmp al, 19
    je keydown_r

    cmp al, 31
    je keydown_s

    cmp al, 20
    je keydown_t

    cmp al, 22
    je keydown_u

    cmp al, 47
    je keydown_v

    cmp al, 17
    je keydown_w

    cmp al, 45
    je keydown_x

    cmp al, 21
    je keydown_y

    cmp al, 44
    je keydown_z

    cmp al, 139
    je keyup_0

    cmp al, 130
    je keyup_1

    cmp al, 131
    je keyup_2

    cmp al, 132
    je keyup_3

    cmp al, 133
    je keyup_4

    cmp al, 134
    je keyup_5

    cmp al, 135
    je keyup_6

    cmp al, 136
    je keyup_7

    cmp al, 137
    je keyup_8

    cmp al, 138
    je keyup_9

    cmp al, 158
    je keyup_a

    cmp al, 176
    je keyup_b

    cmp al, 174
    je keyup_c

    cmp al, 160
    je keyup_d

    cmp al, 146
    je keyup_e

    cmp al, 161
    je keyup_f

    cmp al, 162
    je keyup_g

    cmp al, 163
    je keyup_h

    cmp al, 151
    je keyup_i

    cmp al, 164
    je keyup_j

    cmp al, 165
    je keyup_k

    cmp al, 166
    je keyup_l

    cmp al, 178
    je keyup_m

    cmp al, 177
    je keyup_n

    cmp al, 152
    je keyup_o

    cmp al, 153
    je keyup_p

    cmp al, 144
    je keyup_q

    cmp al, 147
    je keyup_r

    cmp al, 159
    je keyup_s

    cmp al, 148
    je keyup_t

    cmp al, 150
    je keyup_u

    cmp al, 175
    je keyup_v

    cmp al, 145
    je keyup_w

    cmp al, 173
    je keyup_x

    cmp al, 149
    je keyup_y

    cmp al, 172
    je keyup_z

    cmp al, 0x2a
    je keydown_shift

    cmp al, 0x3a
    je keydown_caps

    cmp al, 0xaa
    je keyup_shift

    cmp al, 0xba
    je keyup_caps

    cmp al, 0x39
    je keydown_space

    cmp al, 0xb9
    je keyup_space

    cmp al, 0x1c
    je keydown_enter

    cmp al, 0x9c
    je keyup_enter

    cmp al, 0x0e
    je keydown_back

    cmp al, 0x8e
    je keyup_back

    cmp al, 0x48
    je keydown_up

    cmp al, 0xc8
    je keyup_up

    cmp al, 0x4b
    je keydown_left

    cmp al, 0xcb
    je keyup_left

    cmp al, 0x50
    je keydown_down

    cmp al, 0xd0
    je keyup_down

    cmp al, 0x4d
    je keydown_right

    cmp al, 0xcd
    je keyup_right

    cmp al, 0x1d
    je keydown_ctrl
    

    jmp key_solver_exit


    keydown_ctrl:
        push ax
        mov ax, [ds:Music_on]
        xor ax, 1
        mov [ds:Music_on], ax
        pop ax
        jmp key_solver_exit


    keydown_up:
        mov byte [ds:key_state_up], 1
        jmp key_solver_exit
    keydown_left:
        mov byte [ds:key_state_left], 1
        jmp key_solver_exit
    keydown_right:
        mov byte [ds:key_state_right], 1
        jmp key_solver_exit
    keydown_down:
        mov byte [ds:key_state_down], 1
        jmp key_solver_exit

    keyup_up:
        mov byte [ds:key_state_up], 0
        jmp key_solver_exit
    keyup_left:
        mov byte [ds:key_state_left], 0
        jmp key_solver_exit
    keyup_right:
        mov byte [ds:key_state_right], 0
        jmp key_solver_exit
    keyup_down:
        mov byte [ds:key_state_down], 0
        jmp key_solver_exit

    keydown_back:
        mov byte [ds:key_state_back], 1
        jmp key_solver_exit

    keyup_back:
        mov byte [ds:key_state_back], 0
        jmp key_solver_exit

    keydown_space:
        mov byte [ds:key_state_space], 1
        jmp key_solver_exit

    keydown_enter:
        mov byte [ds:key_state_enter], 1
        jmp key_solver_exit


    keyup_space:
        mov byte [ds:key_state_space], 0
        jmp key_solver_exit

    keyup_enter:
        mov byte [ds:key_state_enter], 0
        jmp key_solver_exit


    keydown_shift:
        mov byte [ds:key_state_shift], 1
        jmp key_solver_exit

    keyup_shift:
        mov byte [ds:key_state_shift], 0
        jmp key_solver_exit

    keydown_caps:
        mov bl, [ds:now_caps]
        xor bl, 1
        mov [ds:now_caps], bl
        jmp key_solver_exit

    keyup_caps:
        jmp key_solver_exit

    keydown_0:
        mov byte [ds:key_state_digit+0], 1
        jmp key_solver_exit

    keydown_1:
        mov byte [ds:key_state_digit+1], 1
        jmp key_solver_exit

    keydown_2:
        mov byte [ds:key_state_digit+2], 1
        jmp key_solver_exit

    keydown_3:
        mov byte [ds:key_state_digit+3], 1
        jmp key_solver_exit

    keydown_4:
        mov byte [ds:key_state_digit+4], 1
        jmp key_solver_exit

    keydown_5:
        mov byte [ds:key_state_digit+5], 1
        jmp key_solver_exit

    keydown_6:
        mov byte [ds:key_state_digit+6], 1
        jmp key_solver_exit

    keydown_7:
        mov byte [ds:key_state_digit+7], 1
        jmp key_solver_exit

    keydown_8:
        mov byte [ds:key_state_digit+8], 1
        jmp key_solver_exit

    keydown_9:
        mov byte [ds:key_state_digit+9], 1
        jmp key_solver_exit

    keydown_a:
        mov byte [ds:key_state_alpha+0], 1
        jmp key_solver_exit

    keydown_b:
        mov byte [ds:key_state_alpha+1], 1
        jmp key_solver_exit

    keydown_c:
        mov byte [ds:key_state_alpha+2], 1
        jmp key_solver_exit

    keydown_d:
        mov byte [ds:key_state_alpha+3], 1
        jmp key_solver_exit

    keydown_e:
        mov byte [ds:key_state_alpha+4], 1
        jmp key_solver_exit

    keydown_f:
        mov byte [ds:key_state_alpha+5], 1
        jmp key_solver_exit

    keydown_g:
        mov byte [ds:key_state_alpha+6], 1
        jmp key_solver_exit

    keydown_h:
        mov byte [ds:key_state_alpha+7], 1
        jmp key_solver_exit

    keydown_i:
        mov byte [ds:key_state_alpha+8], 1
        jmp key_solver_exit

    keydown_j:
        mov byte [ds:key_state_alpha+9], 1
        jmp key_solver_exit

    keydown_k:
        mov byte [ds:key_state_alpha+10], 1
        jmp key_solver_exit

    keydown_l:
        mov byte [ds:key_state_alpha+11], 1
        jmp key_solver_exit

    keydown_m:
        mov byte [ds:key_state_alpha+12], 1
        jmp key_solver_exit

    keydown_n:
        mov byte [ds:key_state_alpha+13], 1
        jmp key_solver_exit

    keydown_o:
        mov byte [ds:key_state_alpha+14], 1
        jmp key_solver_exit

    keydown_p:
        mov byte [ds:key_state_alpha+15], 1
        jmp key_solver_exit

    keydown_q:
        mov byte [ds:key_state_alpha+16], 1
        jmp key_solver_exit

    keydown_r:
        mov byte [ds:key_state_alpha+17], 1
        jmp key_solver_exit

    keydown_s:
        mov byte [ds:key_state_alpha+18], 1
        jmp key_solver_exit

    keydown_t:
        mov byte [ds:key_state_alpha+19], 1
        jmp key_solver_exit

    keydown_u:
        mov byte [ds:key_state_alpha+20], 1
        jmp key_solver_exit

    keydown_v:
        mov byte [ds:key_state_alpha+21], 1
        jmp key_solver_exit

    keydown_w:
        mov byte [ds:key_state_alpha+22], 1
        jmp key_solver_exit

    keydown_x:
        mov byte [ds:key_state_alpha+23], 1
        jmp key_solver_exit

    keydown_y:
        mov byte [ds:key_state_alpha+24], 1
        jmp key_solver_exit

    keydown_z:
        mov byte [ds:key_state_alpha+25], 1
        jmp key_solver_exit

    keyup_0:
        mov byte [ds:key_state_digit+0], 0
        jmp key_solver_exit

    keyup_1:
        mov byte [ds:key_state_digit+1], 0
        jmp key_solver_exit

    keyup_2:
        mov byte [ds:key_state_digit+2], 0
        jmp key_solver_exit

    keyup_3:
        mov byte [ds:key_state_digit+3], 0
        jmp key_solver_exit

    keyup_4:
        mov byte [ds:key_state_digit+4], 0
        jmp key_solver_exit

    keyup_5:
        mov byte [ds:key_state_digit+5], 0
        jmp key_solver_exit

    keyup_6:
        mov byte [ds:key_state_digit+6], 0
        jmp key_solver_exit

    keyup_7:
        mov byte [ds:key_state_digit+7], 0
        jmp key_solver_exit

    keyup_8:
        mov byte [ds:key_state_digit+8], 0
        jmp key_solver_exit

    keyup_9:
        mov byte [ds:key_state_digit+9], 0
        jmp key_solver_exit

    keyup_a:
        mov byte [ds:key_state_alpha+0], 0
        jmp key_solver_exit

    keyup_b:
        mov byte [ds:key_state_alpha+1], 0
        jmp key_solver_exit

    keyup_c:
        mov byte [ds:key_state_alpha+2], 0
        jmp key_solver_exit

    keyup_d:
        mov byte [ds:key_state_alpha+3], 0
        jmp key_solver_exit

    keyup_e:
        mov byte [ds:key_state_alpha+4], 0
        jmp key_solver_exit

    keyup_f:
        mov byte [ds:key_state_alpha+5], 0
        jmp key_solver_exit

    keyup_g:
        mov byte [ds:key_state_alpha+6], 0
        jmp key_solver_exit

    keyup_h:
        mov byte [ds:key_state_alpha+7], 0
        jmp key_solver_exit

    keyup_i:
        mov byte [ds:key_state_alpha+8], 0
        jmp key_solver_exit

    keyup_j:
        mov byte [ds:key_state_alpha+9], 0
        jmp key_solver_exit

    keyup_k:
        mov byte [ds:key_state_alpha+10], 0
        jmp key_solver_exit

    keyup_l:
        mov byte [ds:key_state_alpha+11], 0
        jmp key_solver_exit

    keyup_m:
        mov byte [ds:key_state_alpha+12], 0
        jmp key_solver_exit

    keyup_n:
        mov byte [ds:key_state_alpha+13], 0
        jmp key_solver_exit

    keyup_o:
        mov byte [ds:key_state_alpha+14], 0
        jmp key_solver_exit

    keyup_p:
        mov byte [ds:key_state_alpha+15], 0
        jmp key_solver_exit

    keyup_q:
        mov byte [ds:key_state_alpha+16], 0
        jmp key_solver_exit

    keyup_r:
        mov byte [ds:key_state_alpha+17], 0
        jmp key_solver_exit

    keyup_s:
        mov byte [ds:key_state_alpha+18], 0
        jmp key_solver_exit

    keyup_t:
        mov byte [ds:key_state_alpha+19], 0
        jmp key_solver_exit

    keyup_u:
        mov byte [ds:key_state_alpha+20], 0
        jmp key_solver_exit

    keyup_v:
        mov byte [ds:key_state_alpha+21], 0
        jmp key_solver_exit

    keyup_w:
        mov byte [ds:key_state_alpha+22], 0
        jmp key_solver_exit

    keyup_x:
        mov byte [ds:key_state_alpha+23], 0
        jmp key_solver_exit

    keyup_y:
        mov byte [ds:key_state_alpha+24], 0
        jmp key_solver_exit

    keyup_z:
        mov byte [ds:key_state_alpha+25], 0
        jmp key_solver_exit




key_solver_exit:

    mov dx, 0x20
    mov al, 0x61
    out dx, al

    pop ax
    pop dx
    pop bx
    iret


