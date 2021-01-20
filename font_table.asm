; 自己的文字表

font_table:
dw 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
init_font_table:
	mov word [ds:font_table+0], digit_0
	mov word [ds:font_table+2], digit_1
	mov word [ds:font_table+4], digit_2
	mov word [ds:font_table+6], digit_3
	mov word [ds:font_table+8], digit_4
	mov word [ds:font_table+10], digit_5
	mov word [ds:font_table+12], digit_6
	mov word [ds:font_table+14], digit_7
	mov word [ds:font_table+16], digit_8
	mov word [ds:font_table+18], digit_9
	mov word [ds:font_table+20], font_A
	mov word [ds:font_table+22], font_B
	mov word [ds:font_table+24], font_C
	mov word [ds:font_table+26], font_D
	mov word [ds:font_table+28], font_E
	mov word [ds:font_table+30], font_F
	mov word [ds:font_table+32], font_G
	mov word [ds:font_table+34], font_H
	mov word [ds:font_table+36], font_I
	mov word [ds:font_table+38], font_J
	mov word [ds:font_table+40], font_K
	mov word [ds:font_table+42], font_L
	mov word [ds:font_table+44], font_M
	mov word [ds:font_table+46], font_N
	mov word [ds:font_table+48], font_O
	mov word [ds:font_table+50], font_P
	mov word [ds:font_table+52], font_Q
	mov word [ds:font_table+54], font_R
	mov word [ds:font_table+56], font_S
	mov word [ds:font_table+58], font_T
	mov word [ds:font_table+60], font_U
	mov word [ds:font_table+62], font_V
	mov word [ds:font_table+64], font_W
	mov word [ds:font_table+66], font_X
	mov word [ds:font_table+68], font_Y
	mov word [ds:font_table+70], font_Z
	mov word [ds:font_table+72], font_cap_A
	mov word [ds:font_table+74], font_cap_B
	mov word [ds:font_table+76], font_cap_C
	mov word [ds:font_table+78], font_cap_D
	mov word [ds:font_table+80], font_cap_E
	mov word [ds:font_table+82], font_cap_F
	mov word [ds:font_table+84], font_cap_G
	mov word [ds:font_table+86], font_cap_H
	mov word [ds:font_table+88], font_cap_I
	mov word [ds:font_table+90], font_cap_J
	mov word [ds:font_table+92], font_cap_K
	mov word [ds:font_table+94], font_cap_L
	mov word [ds:font_table+96], font_cap_M
	mov word [ds:font_table+98], font_cap_N
	mov word [ds:font_table+100], font_cap_O
	mov word [ds:font_table+102], font_cap_P
	mov word [ds:font_table+104], font_cap_Q
	mov word [ds:font_table+106], font_cap_R
	mov word [ds:font_table+108], font_cap_S
	mov word [ds:font_table+110], font_cap_T
	mov word [ds:font_table+112], font_cap_U
	mov word [ds:font_table+114], font_cap_V
	mov word [ds:font_table+116], font_cap_W
	mov word [ds:font_table+118], font_cap_X
	mov word [ds:font_table+120], font_cap_Y
	mov word [ds:font_table+122], font_cap_Z
	ret
