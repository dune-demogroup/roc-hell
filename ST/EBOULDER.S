UNDO_KEY equ $16
PREVIOUS_LEVEL_KEY equ $3B
NEXT_LEVEL_KEY equ $3C
RELOAD_KEY equ $3D
SAVE_KEY equ $3E
PREVIOUS_TYPE_KEY equ $3F
NEXT_TYPE_KEY equ $40
FILL_KEY equ $41
LINE_KEY equ $42
SET_LEVEL_LIMIT_KEY equ $43
NEXT_BNK_KEY equ $44
	section data
animate_is_state
	dc.b	0, 0, 0, 0
	dc.b	0, 0, 0, 0
	dc.b	0, 0, 0, 0
	dc.b	0, 0, 3, 3
	dc.b	7, 1, 0, 2
	dc.b	2, 0, 0, 0
	dc.b	0, 0, 0, 0
	dc.b	0, 0, 0, 0
current_animate_is_state
	dc.b	0,0
	even

	section text
reload_level:
	move.w pos_hero,pos_editor
	move #1,mouse_display
	bsr	clear_map
	lea map_anim,a0
	move.w	#MAX_MAP_X*MAX_MAP_Y-1,d0
.loop1
	clr		(a0)+
	dbra	d0,.loop1

	bsr	loadlevel
	bsr	makelevel
	
	
	lea	map,a0
	moveq	#0,d0
	move.w	pos_hero,d0
	move.w	d0,d1
	and.w	#MAP_MASK_Y,d0
	move.b	#3,(a0,d0.l)
	move.w pos_editor,pos_hero

	and #$FFFE,edit_type

	lea map,a0
	lea map_anim,a1
	move.w	#MAX_MAP_X*MAX_MAP_Y-1,d0
.loop2
	cmp.b	#TYPE_MAGIC_BRICK,(a0)+
	bne		.not_magic
	move.b	#1*4,(a1)
.not_magic
	lea	1(a1),a1
	dbra	d0,.loop2
	
	bsr		save_restore

	rts

inv_icon:
	lea menu+32,a0
	lsr #1,d1
	move d1,d2
	and #$fff8,d2
	lsr	#2,d1
	and #1,d1
	add d2,d1
	lea	(a0,d1),a0
v	set	0
	rept	8
	not.b	v(a0)
	not.b	v+4(a0)
v	set	v+160
	endr
	rts


fill:
	lea		map,a0
	move.w	tofill,d0
	move.b	(a0,d0),d1
	moveq	#0,d6
	move.b	type_of_tile,d2
	move.b	d2,(a0,d0)
.fill_loop:
	subq	#1,d7
	bmi		.end
	lea		map,a0
	lea		tofill,a6
	add		d6,a6
	eor		#256*4*2,d6
	lea		tofill,a5
	add		d6,a5
	move.w	#MAP_MASK_Y,d4
	moveq	#0,d3
.loop
	move.w	(a6)+,d0
	subq.b	#1,d0
	bcs		.right
	
	cmp.b	(a0,d0),d1
	bne		.right
	move.b	d2,(a0,d0)
	move.w	d0,(a5)+
	addq	#1,d3
.right
	addq.b	#2,d0
	beq		.up
	cmp.b	(a0,d0),d1
	bne		.up
	move.b	d2,(a0,d0)
	move.w	d0,(a5)+
	addq	#1,d3
.up
	subq.b	#1,d0
	sub		#MAX_MAP_X,d0
	bcs		.down
	cmp.b	(a0,d0),d1
	bne		.down
	move.b	d2,(a0,d0)
	move.w	d0,(a5)+
	addq	#1,d3
.down
	add		#MAX_MAP_X*2,d0
	cmp		#MAX_MAP_Y*256,d0
	bge		.next
	cmp.b	(a0,d0),d1
	bne		.next
	move.b	d2,(a0,d0)
	move.w	d0,(a5)+
	addq	#1,d3
.next
	dbra	d7,.loop
	move	d3,d7
	cmp		#$39,$fffffc02.w
	bne		.fill_loop
	movem.w	d1/d2/d6/d7,-(sp)
	move	d0,d1
	bsr		display_map
	bsr		swap
	movem.w	(sp)+,d1/d2/d6/d7
	bra		.fill_loop
.end
	rts
	section bss
tofill	
	ds.w 256*8
	

	section text
*************************************
*a0:dst1 (map)
*a1:dst2 (map_anim)
*d0/d1: pt1
*d2/d3: pt2
*d6:tile_type
*d7:anim
*************************************
line:
	sub		d0,d2
	sub		d1,d3
	move	d2,d4
	bgt		.dx_pos
	neg		d4
.dx_pos
	move	d3,d5
	bgt		.dy_pos
	neg		d5
.dy_pos
	cmp		d4,d5
	bgt		.y_way
	tst		d2
	bge		.not_swap_x
	add		d2,d0
	neg		d2
	add		d3,d1
	neg		d3
	neg		d5
.not_swap_x
	add		d3,d1
	lsl		#8,d1
	add		d0,d1
	lea		(a0,d1),a0
	lea		(a1,d1),a1
	move.w	#-MAX_MAP_X,d5
	tst		d3
	bge		.not_neg_dy
	neg		d5
	neg		d3
.not_neg_dy
	move	d3,d4
	add		d4,d4
	move	d4,d1
	sub		d2,d4
	move.b	type_of_tile,d6
	move.b	current_animate_is_state,d7
	move.w	d2,d0
	add		d0,d0
.loop_x:
	move.b	d6,(a0,d2)
	move.b	d7,(a1,d2)
	tst		d4
	blt		.ok_x
	lea		(a0,d5),a0
	lea		(a1,d5),a1
	sub		d0,d4
.ok_x
	add		d1,d4
	dbra	d2,.loop_x
	rts

.y_way
	tst		d3
	bge		.not_swap_y
	add		d3,d1
	neg		d3
	add		d2,d0
	neg		d2
.not_swap_y
	add		d2,d0
	lsl		#8,d1
	add		d0,d1
	lea		(a0,d1),a0
	lea		(a1,d1),a1
	move.w	#-1,d5
	tst		d2
	bge		.not_neg_dx
	neg		d5
	neg		d2
.not_neg_dx
	move	d2,d4
	add		d4,d4
	move	d4,d1
	sub		d3,d4
	move.b	type_of_tile,d6
	move.b	current_animate_is_state,d7
	move.w	d3,d0
	add		d0,d0
.loop_y:
	move	d3,d2
	lsl		#8,d2
	move.b	d6,(a0,d2)
	move.b	d7,(a1,d2)
	tst		d4
	blt		.ok_y
	lea		(a0,d5),a0
	lea		(a1,d5),a1
	sub		d0,d4
.ok_y
	add		d1,d4
	dbra	d3,.loop_y
	rts


	section text
save_restore
	lea		map,a5
	lea		for_restore,a6
	move.w	#((MAX_MAP_X*MAX_MAP_Y*2)/4)-1,d7
.loop
	move.l	(a5)+,(a6)+
	dbra	d7,.loop
	rts
restore_restore:

	lea		map,a5
	lea		for_restore,a6
	move.w	#((MAX_MAP_X*MAX_MAP_Y*2)/4)-1,d7
.loop
	move.l	(a6)+,(a5)+
	dbra	d7,.loop
	rts
	section	bss
for_restore
	ds.b	MAX_MAP_X*MAX_MAP_Y*2


	section text
check_edit_type:
	move.w	edit_type,d6
	move.w	old_edit_type,d7
	move.w	d6,old_edit_type
	eor.w	d6,d7
	btst	#0,d7
	beq		.not_1
	moveq	#24,d1
	bsr		inv_icon
.not_1
	btst	#2,d7
	beq		.not_2
	moveq	#64,d1
	bsr		inv_icon
.not_2
	btst	#1,d7
	beq		.not_3
	moveq	#48,d1
	bsr		inv_icon
.not_3
	btst	#3,d7
	beq		.not_4
	moveq	#56,d1
	bsr		inv_icon
	btst	#4,d7
	beq		.not_4
	movem.w	d6/d7,-(sp)
	bsr		restore_restore
	movem.w	(sp)+,d6/d7
.not_4	
	rts


**********************
	section text
edit_boulder	
	move.w	edit_type,old_edit_type
	
	lea	menu,a0
	bsr		settimerb2_palette
	bsr		clear_map
	bsr		cls
	bsr		swap
	bsr		cls
	move.b	#10,x_hero
	move.b	#6,y_hero
	
	tst.w	use_memory_disk
	bne		.noboot
	move.l	#boot_name,FILENAME_LOAD
	bsr		open
	blt		.noboot 
	move.l	#current_level,LOAD_SAVE_BUF
	move.l	#2,LOAD_SAVE_LENGTH
	bsr		load
	move.l	#pos_editor,LOAD_SAVE_BUF
	move.l	#2,LOAD_SAVE_LENGTH
	bsr		load
	move.w	pos_editor,pos_hero
	bsr		close
.noboot	
	bsr		reload_level

	clr.w	use_memory_disk
	movem.l	palette,d0-d7
	movem.l	d0-d7,$ffff8240.w
.loop	
	bsr	vsync
****SOUND TEST
	moveq	#0,d0
	move.b	thekey,d0
	cmp.b	#$1E,d0
	bmi		.no_test_sound
	cmp.b	#$35,d0
	bgt		.no_test_sound
	move.w	d0,-(sp)
	bsr		reload_sound_bank
	move.w	(sp)+,d0
	sub		#$1E,d0
	add		d0,d0
	lea		sound_bank,a0
	move.w	(a0),d1
	cmp		d1,d0
	bmi		.test_sound
	clr.w	sound_b
	bra		.no_test_sound
.test_sound
	clr.w	sound_b_cursor
	move.w	(a0,d0),sound_b
	move.w	#-4,sound_b_lp
.no_test_sound
****SOUND TEST


	move.b	joy_directions,d0

	btst	#0,d0
	beq		.joy_ok0
	subq.b	#1,y_hero
	bra		.end_joy
.joy_ok0	
	btst	#1,d0
	beq		.joy_ok1
	addq.b	#1,y_hero
	bra		.end_joy
.joy_ok1	
	btst	#2,d0
	beq		.joy_ok2
	subq.b	#1,x_hero
	bra		.end_joy
.joy_ok2
	btst	#3,d0
	beq		.joy_ok3
	addq.b	#1,x_hero
.joy_ok3	
	tst.b	thekeymap+$48
	beq		.joy_ok4
	subq.b	#1,y_hero
.joy_ok4
	tst.b	thekeymap+$50
	beq		.joy_ok5
	addq.b	#1,y_hero
.joy_ok5	
	tst.b	thekeymap+$4B
	beq		.joy_ok6
	subq.b	#1,x_hero
.joy_ok6
	tst.b	thekeymap+$4D
	beq		.end_joy
	addq.b	#1,x_hero
.end_joy
	move.w	pos_hero,d0
	move.w	level_limit,d1
	sub.b	#10,d0
	bcc		.no_clap_hero1
	clr.b	d0
.no_clap_hero1
	sub.w	#6*256,d0
	bcc		.no_clap_hero3
	and.w	#$FF,d0
.no_clap_hero3
	cmp.b	d1,d0
	bcs		.no_clap_hero2
	move.b	d1,d0
.no_clap_hero2
	cmp.w	d1,d0
	bcs		.no_clap_hero4
	and.w	#$ff,d0
	and.w	#$ff00,d1
	or.w	d1,d0
.no_clap_hero4
	add.w	#256*6+10,d0
	move.w	d0,pos_hero

	move.l	mouse_pt,d0
	swap	d0
	tst		d0
	bge		.ok6
	eor.w	d0,d0
	move.w	d0,xpt
.ok6	
	cmp		#320,d0
	blt		.ok7
	move.w	#319,d0
	move.w	d0,xpt
.ok7
	move.w	d0,d2
	swap	d0
	tst		d0
	bge		.ok8
	eor.w	d0,d0
	move.w	d0,ypt
.ok8
	cmp		#192,d0
	blt		.ok9
	move.w	#191,d0
	move.w	d0,ypt
.ok9
	move.w	d0,d3
	
	cmp		#8,d0
	bge		.editlevel
	btst	#0,joy_buttons
	beq		.okboutmenu
	swap	d0
	cmp		#8,d0
	bge		.not_plevel	
	move.b	#PREVIOUS_LEVEL_KEY,thekey
	bra		.endmenu
.not_plevel	
	cmp		#16,d0
	bge		.not_nlevel
	move.b	#NEXT_LEVEL_KEY,thekey
	bra		.endmenu
.not_nlevel
	cmp		#24,d0
	bge		.not_rlevel
	move.b	#RELOAD_KEY,thekey
	bra		.endmenu
.not_rlevel
	cmp		#32,d0
	bge		.not_slevel
	move.b	#SAVE_KEY,thekey
	bra		.endmenu
.not_slevel
	cmp		#40,d0
	bge		.not_ptype
	move.b	#PREVIOUS_TYPE_KEY,thekey
	bra		.endmenu
.not_ptype
	cmp		#48,d0
	bge		.not_ntype
	move.b	#NEXT_TYPE_KEY,thekey
	bra		.endmenu
.not_ntype
	cmp		#56,d0
	bge		.not_fedit
	move.b	#FILL_KEY,thekey
	bra		.endmenu
.not_fedit
	cmp		#64,d0
	bge		.not_ledit
	move.b	#LINE_KEY,thekey
	bra		.endmenu
.not_ledit
	cmp		#72,d0
	bge		.not_lllevel
	move.b	#SET_LEVEL_LIMIT_KEY,thekey
	bra		.endmenu
.not_lllevel
	cmp		#80,d0
	bge		.not_nothing_1
	bra		.endmenu
.not_nothing_1
	cmp		#96,d0
	bge		.not_animate_state
	lea		current_animate_is_state,a0
	move.b	(a0)+,d1
	addq.b	#1,(a0)
	cmp.b	(a0),d1
	bge		.endmenu
	clr.b	(a0)
	bra		.endmenu
.not_animate_state
	cmp		#112,d0
	bge		.not_diamnds_count
	addq.b	#1,diamonds_sup_count
	bra		.endmenu
.not_diamnds_count
.endmenu
	swap	d0
	bclr	#0,joy_buttons
.okboutmenu
	btst	#1,joy_buttons
	beq		.okbout2menu
	swap	d0
	cmp		#88,d0
	blt		.endmenu
	cmp		#96,d0
	bge		.okmenu_b_1
	bra		.endmenu2
.okmenu_b_1
	cmp		#112,d0
	bge		.okmenu_b_2
	subq.b	#1,diamonds_sup_count
	bra		.endmenu2
.okmenu_b_2
.endmenu2
	swap	d0
	bclr	#1,joy_buttons
.okbout2menu
	move.l	#mouse_pointer,mouse_motif
	move.l	#mouse_pointer_mask,mouse_mask
	move.l	d0,mouse
	and		#MAP_MASK_Y,pos_hero
	bsr		get_displayed_map
	lea		map,a0
	lea		(a0,d1),a0
	lea		map_anim,a1
	lea		(a1,d1),a1
	move.b	(a1),d2

	move.b	current_animate_is_state+1,d0
	lsl		#2,d0

	cmp.b	#TYPE_MAGIC_BRICK,type_of_tile
	bne		.not_magic2
	move.b	#1*4,d0
.not_magic2
	move.b	d0,(a1)
	move.b	(a0),d0
	move.b	type_of_tile,(a0)
	movem.l	d0/d2/a0/a1,-(sp)	
	bsr		display_map
	movem.l	(sp)+,d0/d2/a0/a1
	move.b	d0,(a0)
	move.b	d2,(a1)
	bra		.endedit
.editlevel
	move.l	#mouse_pointer_box,mouse_motif
	move.l	#mouse_pointer_box_mask,mouse_mask
	and.l	#$FFF0FFF0,d0
	add.w	#8,d0
	move.l	d0,mouse

	and		#MAP_MASK_Y,pos_hero
	bsr		get_displayed_map
	lsr.w	#4,d2
	lsl.w	#4,d3
	and.w	#$ff00,d3
	add		d1,d2
	add		d2,d3
	moveq	#0,d0
	move.w	d3,d0
	lea		map,a0
	lea		(a0,d0),a0
	lea		map_anim,a1
	lea		(a1,d0),a1

	move.b	(a1),d2
	move.b	current_animate_is_state+1,d0
	lsl		#2,d0
	cmp.b	#TYPE_MAGIC_BRICK,type_of_tile
	bne		.not_magic3
	move.b	#1*4,d0
.not_magic3
	move.b	d0,(a1)
	move.b	(a0),d0
	move.b	type_of_tile,(a0)
	movem.l	d0/d2/a0/a1,-(sp)	
	bsr		display_map
	movem.l	(sp)+,d0/d2/a0/a1
	move.b	d0,(a0)
	move.b	d2,(a1)
	
	btst	#0,joy_buttons
	beq		.no_edit_type
	move	edit_type,d1
	move	#$FFFE,d2
	and		d1,d2
	bne		.no_edit_normal
	move.b	type_of_tile,d0
	and.b	#$1f,d0
	move.b	d0,(a0)
	cmp.b	#TYPE_MAGIC_BRICK,d0
	bne		.not_magic
	move.b	#1*4,(a1)
	bra		.end_edit_type
.not_magic
	move.b	current_animate_is_state+1,d0
	lsl		#2,d0
	move.b	d0,(a1)
	bra		.end_edit_type
.no_edit_normal
	btst	#1,d1
	beq		.no_fill
	bclr	#1,d1
	move	d1,edit_type
	move.b	type_of_tile,d0
	and.b	#$1f,d0
	cmp.b	(a0),d0
	beq		.end_edit_type
	bsr		save_restore
	moveq	#1,d7
	move.l	a0,d0
	sub.l	#map,d0
	move.w	d0,tofill

	bsr		fill
	bclr	#0,joy_buttons
	bra		.end_edit_type
.no_fill
	btst	#2,d1
	beq		.no_set_limit
	bclr	#2,d1
	move	d1,edit_type
	move.l	a0,d0
	sub.l	#map,d0
	sub.w	#256*11+19,d0
	move.w	d0,level_limit
	bclr	#0,joy_buttons
	bra		.end_edit_type
.no_set_limit
	btst	#3,d1
	beq		.no_line_pt1
	btst	#4,d1
	beq		.no_line_pt2
	move.l	a0,-(sp)
	bclr	#4,d1
	move	d1,edit_type
	move.l	a0,d1
	sub.l	#map,d1
	moveq	#0,d0
	move.b	d1,d0
	lsr		#8,d1
	move.w	.line_pt1,d3
	moveq	#0,d2
	move.b	d3,d2
	lsr		#8,d3
	lea		map,a0
	lea		map_anim,a1
	bsr		line
	bclr	#0,joy_buttons
	move.l	(sp)+,a0
	bra		.end_edit_type
.no_line_pt2
	bset	#4,d1
	move	d1,edit_type
	move.l	a0,d0
	sub.l	#map,d0
	bsr		save_restore
	move.w	d0,.line_pt1
	bclr	#0,joy_buttons
	bra		.end_edit_type
.line_pt1	dc.b 0,0
.no_line_pt1

.end_edit_type
	or		#1,edit_type
.no_edit_type
	move	edit_type,d1
	btst	#4,d1
	beq		.no_display_line
	move.l	a0,-(sp)
	bsr		restore_restore
	move.l	a0,d1
	sub.l	#map,d1
	moveq	#0,d0
	move.b	d1,d0
	lsr		#8,d1
	move.w	.line_pt1,d3
	moveq	#0,d2
	move.b	d3,d2
	lsr		#8,d3
	lea		map,a0
	lea		map_anim,a1
	bsr		line
	move.l	(sp)+,a0
.no_display_line


	btst	#1,joy_buttons
	beq		.okbout2
	move	edit_type,d1
	move.w	#16,d2
	and		d1,d2
	beq		.base_edit_mode
	bsr		restore_restore
	bclr	#4,d1
	move.w	d1,edit_type
	bra		.okbout2
.base_edit_mode
	move.b	d0,type_of_tile
.okbout2
.endedit
	cmp.b	#$39,thekey
	bne		.nodisplaybnk
	bsr		display_bank
.nodisplaybnk


	lea		menu+32,a1
	move.l	screen,a0
	move	#((320*8)/(2*4))-1,d0
.loopdisplaymenu
	move.l (a1)+,(a0)+
	dbra	d0,.loopdisplaymenu

	lea		current_animate_is_state,a0
	tst.b	(a0)+
	beq		.not_animate_is_state
	moveq	#1,d0
	move.b	(a0),d0
	move.l	screen,a0
	add.l	#40,a0
	moveq	#1,d7
	bsr		bindec	
.not_animate_is_state

	move.l	screen,a0
	add.l	#48,a0
	moveq	#0,d0
	move.b	diamonds_sup_count,d0
	moveq	#3,d7
	bsr		bindec

	move.l	screen,a0
	add.l	#80,a0
	moveq	#0,d0
	move.b	x_hero,d0
	moveq	#3,d7
	bsr		bindec

	move.l	screen,a0
	add.l	#16+80,a0
	moveq	#0,d0
	move.b	y_hero,d0
	moveq	#2,d7
	bsr		bindec
	
	move.l	screen,a0
	add.l	#112,a0
	moveq	#0,d0
	move.w	max_diamonds,d0
	moveq	#3,d7
	bsr		bindec
	
	move.l	screen,a0
	add.l	#16+112,a0
	moveq	#0,d0
	move.w	current_level,d0
	moveq	#3,d7
	bsr		bindec

	bsr		swap
	
	move.b	thekey,d0
	cmp.b	#PREVIOUS_TYPE_KEY,d0
	bne	.notprevioustype
	moveq	#0,d0
	move.b	type_of_tile,d0
	subq.b	#1,d0
	tst.b	d0
	bge		.dont_clamp_type1
	move.b	#TYPE_MAX-1,d0
.dont_clamp_type1
	move.b	d0,type_of_tile
	lea		animate_is_state,a0
	move.b	(a0,d0),d1
	move.b	d1,current_animate_is_state
	clr.b	current_animate_is_state+1
	clr.b	thekey
	bra		.end_keystroke
.notprevioustype	
	cmp.b	#NEXT_TYPE_KEY,d0
	bne		.notnexttype
	moveq	#0,d0
	move.b	type_of_tile,d0
	addq.b	#1,d0
	cmp.b	#TYPE_MAX,d0
	bmi		.dont_clamp_type2
	clr.b	d0
.dont_clamp_type2
	move.b	d0,type_of_tile
	lea		animate_is_state,a0
	move.b	(a0,d0),d1
	move.b	d1,current_animate_is_state
	clr.b	current_animate_is_state+1
	clr.b	thekey
	bra		.end_keystroke
.notnexttype
	cmp.b	#UNDO_KEY,d0
	bne		.not_undo
	bsr		restore_restore
.not_undo
	cmp.b	#SAVE_KEY,d0
	bne		.notsave
	move.w	pos_hero,pos_editor
	bsr		savelevel
	move.w	pos_editor,pos_hero
	clr.b	 thekey
	bra		.end_keystroke
.notsave
	cmp.b	#RELOAD_KEY,d0
	bne		.notload
	bsr		reload_level
	clr.b	thekey
	bra		.end_keystroke
.notload
	cmp.b	#PREVIOUS_LEVEL_KEY,d0
	bne		.not_sub_level
	tst		current_level
	beq		.end_keystroke
	clr.b	thekey
	subq	#1,current_level
	bsr		reload_level
	bra		.end_keystroke
.not_sub_level
	cmp.b	#NEXT_LEVEL_KEY,d0
	bne		.not_add_level
	clr.b	thekey
	addq	#1,current_level
	bsr		reload_level
	bra		.end_keystroke

.not_add_level	
	cmp.b	#FILL_KEY,d0
	bne		.not_fill_key
	move	edit_type,d1
	and		#$3,d1
	bchg	#1,d1
	move	d1,edit_type
	clr.b	thekey
	bra		.end_keystroke
.not_fill_key
	cmp.b	#LINE_KEY,d0
	bne		.not_line_key
	move	edit_type,d1
	and		#$9,d1
	bchg	#3,d1
	move	d1,edit_type
	clr.b	thekey
	bra		.end_keystroke
.not_line_key
	cmp.b	#NEXT_BNK_KEY,d0
	bne		.nonextbnk
	cmp.b	#"5",picture_name+1
	beq		.first_bnk
	addq.b	#1,picture_name+1
	bra		.load_bnk
.first_bnk
	move.b	#"1",picture_name+1
.load_bnk
	bsr		load_bnk
	clr.b	thekey
	bra		.end_keystroke
.nonextbnk
	cmp.b	#SET_LEVEL_LIMIT_KEY,d0
	bne		.no_set_level_limit
	move.b	#64-12,level_limit
	move.b	#256-20,level_limit+1
	move	edit_type,d1
	and		#$5,d1
	bchg	#2,d1
	move	d1,edit_type
	clr.b	thekey
	bra		.end_keystroke
.no_set_level_limit
	cmp.b	#SWAP_KEY,d0
	seq	d2
	cmp.b	#QUIT_KEY,d0
	seq		d1
	or.b	d1,d2
	tst.b	d2
	bne		.end_edit_all
.end_keystroke
	bsr		check_edit_type

	bra		.loop

.end_edit_all
	cmp.b	#QUIT_KEY,d0
	bne		.test
	lea		quit_text,a0
	bsr		copy_scroll_text
	st		scroll_active

.wait_end_quit_key
	bsr		vsync
	cmp.b	#QUIT_KEY,thekey
	beq		.wait_end_quit_key
.loop_wait_end_key
	bsr		vsync
	cmp.b	#$15,thekey
	beq		.save_before_quit
	tst.b	thekey
	ble		.loop_wait_end_key
	
	sf		scroll_active
	cmp.b	#QUIT_KEY,thekey
	bne		.loop
	clr.w	d0
	rts
.save_before_quit
	move.l	#boot_name,FILENAME_LOAD
	bsr		create
	move.l	#current_level,LOAD_SAVE_BUF
	move.l	#2,LOAD_SAVE_LENGTH
	bsr		save
	move.l	#pos_hero,LOAD_SAVE_BUF
	move.l	#2,LOAD_SAVE_LENGTH
	bsr		save
	bsr		close
	bsr		savelevel
	clr.w	d0
	rts
.test
	move.w	#1,use_memory_disk
	bsr		savelevel

	clr		mouse_display
	moveq	#1,d0
	rts

quit_text
	dc.b	"TYPE Y TO SAVE ;; ESC TO QUIT WITHOUT SAVING ;; ALL OTHER KEY CONTINUE TO EDIT :::::::    ",0
	even
******************************************************
******************************************************
******************************************************
******************************************************
	******************************************************
******************************************************
saveerror:
	bsr	close
	bsr	restore_vec
	bsr	init_vec
	move.w	#$700,$FFFF8240
	bsr vsync
	bsr vsync
	bsr vsync
	bsr vsync
	bsr vsync
	rts

PARSE_OBJECTS	macro 1
	move	#\1,d7
	bsr parse_objects_ 
	endm

parse_objects_:
	moveq	#0,d0
	lea		objects_count,a5
	add		d7,d7
	move	(a5,d7),d0
	move	-2(a5,d7),d7
	sub		d7,d0
	lea		objects,a3
	lea		(a3,d7.l),a3
	lsr		#2,d0
	move	d0,(a2)
	subq	#1,d0
	bmi		.end
.loop
	move	(a3)+,(a0)+
	addq	#2,a3
	dbra	d0,.loop
.end
	move.l	a0,a2
	lea		2(a2),a0
	rts

PARSE_OBJECTS_AND_ANIM	macro 1
	move	#\1,d7
	bsr parse_objects_and_anim_
	endm
parse_objects_and_anim_:
	moveq	#0,d0
	lea		objects_count,a5
	add		d7,d7
	move	(a5,d7),d0
	move	-2(a5,d7),d7
	sub		d7,d0
	lea		objects,a3
	lea		(a3,d7.l),a3
	lsr		#2,d0
	move.w	d0,(a2)
	subq	#1,d0
	bmi		.end
.loop
	move.l	(a3)+,(a0)+
	dbra	d0,.loop
.end
	move.l	a0,a2
	lea		2(a2),a0
	rts

parse_objects_cumul_:
	moveq	#0,d0
	moveq	#0,d1
	lea		objects_count,a0
	moveq	#(256/4)-1,d0
	moveq	#0,d1
.loop_clr:
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbra	d0,.loop_clr
	moveq	#0,d7
	lea		objects_count,a0

	lea		map,a1
	move.w	#$3FFF,d0
.loop
	move.b	(a1,d0),d7
	add		d7,d7
	addq.w	#4,(a0,d7)
	dbra	d0,.loop
	clr.w	2(a0)
	
	move.w	#255,d0
	moveq	#0,d1
	move.l	a0,a2
.loop_cumul:
	move.w	(a0),d2
	move.w	d1,(a0)+
	add		d2,d1
	dbra	d0,.loop_cumul

	lea		map_anim,a3
	lea		objects,a0
	move.w	#$3FFF,d0
	moveq	#0,d1
	moveq	#1,d7
	moveq	#0,d2
.loop2
	move.b	(a1,d0),d1
	cmp.b	d1,d7
	beq		.not_dirt
	add		d1,d1
	move.w	(a2,d1),d2
	move.w	d0,(a0,d2.l)
	move.b	(a3,d0),d3
	move.b	d3,2(a0,d2.l)
	addq	#4,d2
	move	d2,(a2,d1)
.not_dirt
	dbra	d0,.loop2
	move.w	#255*2,d1
	move.w	(a2,d1),d2
	lea		(a0,d2.l),a2
	rts


	section	bss
	ds.w	1
objects_count	
	ds.w	256
	section text
savelevel:
	move.l	#namesave,FILENAME_SAVE
	bsr	create
	bmi saveerror
	


	bsr		parse_objects_cumul_
	lea		objects_count,a0
	lea		objects,a1
	move.w	TYPE_DOOR*2-2(a0),d0
	move.w	(a1,d0.l),door
	move.w	TYPE_ANT*2-2(a0),d0
	move.w	(a1,d0.l),pos_hero

	move.l	a2,a6
	lea		2(a2),a0
	PARSE_OBJECTS TYPE_NULL
	PARSE_OBJECTS TYPE_BRICK
	PARSE_OBJECTS TYPE_ROCK
	PARSE_OBJECTS TYPE_DIAMOND
	PARSE_OBJECTS TYPE_FIREFLY
	PARSE_OBJECTS TYPE_BUTTERFLY
	PARSE_OBJECTS TYPE_AMOEBA
	PARSE_OBJECTS TYPE_BORDERBRICK
	PARSE_OBJECTS TYPE_MAGIC_BRICK
	PARSE_OBJECTS TYPE_TIME
	PARSE_OBJECTS TYPE_DUST
	PARSE_OBJECTS TYPE_DEVIL1
	PARSE_OBJECTS TYPE_DEVIL2
	PARSE_OBJECTS TYPE_SLIME
	PARSE_OBJECTS_AND_ANIM TYPE_LOCKER
	PARSE_OBJECTS_AND_ANIM TYPE_KEY
	PARSE_OBJECTS_AND_ANIM TYPE_BOMB
	PARSE_OBJECTS_AND_ANIM TYPE_APPLE
	PARSE_OBJECTS_AND_ANIM TYPE_HARD_ROCK
	PARSE_OBJECTS_AND_ANIM TYPE_GEM

	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#current_version,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror
	
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#level_limit,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror

	move.l	#1,LOAD_SAVE_LENGTH
	move.l	#picture_name+1,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror

	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#door,LOAD_SAVE_BUF
	bsr	save		
	bmi saveerror

	move.l	#1,LOAD_SAVE_LENGTH
	move.l	#diamonds_sup_count,LOAD_SAVE_BUF
	bsr	save	
	bmi saveerror

	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#pos_hero,LOAD_SAVE_BUF
	bsr	save		
	bmi saveerror

	moveq	#TYPE_OBJECTS_COUNT-1,d5
.loopsave_objects	
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	a6,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror
	
	moveq	#0,LOAD_SAVE_LENGTH
	move.w	(a6),LOAD_SAVE_LENGTH
	add.w	LOAD_SAVE_LENGTH,LOAD_SAVE_LENGTH
	addq.l	#2,a6
	move.l	a6,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror
	lea	(a6,LOAD_SAVE_LENGTH),a6
	dbra	d5,.loopsave_objects

	moveq	#TYPE_OBJECTS_AND_ANIM_COUNT-1,d5
.loopsave_objects_and_anim
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	a6,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror
	
	moveq	#0,LOAD_SAVE_LENGTH
	move.w	(a6),LOAD_SAVE_LENGTH
	add.w	LOAD_SAVE_LENGTH,LOAD_SAVE_LENGTH
	add.w	LOAD_SAVE_LENGTH,LOAD_SAVE_LENGTH
	addq.l	#2,a6
	move.l	a6,LOAD_SAVE_BUF
	bsr	save
	bmi saveerror
	lea	(a6,LOAD_SAVE_LENGTH),a6
	dbra	d5,.loopsave_objects_and_anim

	bsr	close
	and #$FFFE,edit_type

	rts

*****************************************
**in:d1 -> left/top corner
*****************************************
display_bank:
	move.l	screen,a1
	lea	8*160(a1),a1
	lea	sprite_bnk,a2	
	lea	BASE_SPRITE_MSK(a2),a3
	
	moveq	#TILE_COUNT_HEIGHT-1,d6
.loopy
	moveq	#TILE_COUNT_WIDTH-1,d7
.loopx
	movem.w	d6/d7,-(sp)
	movem.l	(a2)+,d0-d7

	cmp.l	a3,a2
	bge		.mask
	movem.l	d0/d1,(a1)
	movem.l	d2/d3,160(a1)
	movem.l	d4/d5,320(a1)
	movem.l	d6/d7,480(a1)
	movem.l	(a2)+,d0-d7
	movem.l	d0/d1,640(a1)
	movem.l	d2/d3,800(a1)
	movem.l	d4/d5,960(a1)
	movem.l	d6/d7,1120(a1)
	movem.l	(a2)+,d0-d7
	movem.l	d0/d1,1280(a1)
	movem.l	d2/d3,1440(a1)
	movem.l	d4/d5,1600(a1)
	movem.l	d6/d7,1760(a1)
	movem.l	(a2)+,d0-d7
	movem.l	d0/d1,1920(a1)
	movem.l	d2/d3,2080(a1)
	movem.l	d4/d5,2240(a1)
	movem.l	d6/d7,2400(a1)
	bra		.next
.mask
	swap	d0
	move.w	d0,(a1)
	move.w	d0,2(a1)
	move.w	d0,4(a1)
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,160(a1)
	move.w	d0,162(a1)
	move.w	d0,164(a1)
	move.w	d0,166(a1)
	swap	d1
	move.w	d1,320(a1)
	move.w	d1,322(a1)
	move.w	d1,324(a1)
	move.w	d1,326(a1)
	swap	d1
	move.w	d1,480(a1)
	move.w	d1,482(a1)
	move.w	d1,484(a1)
	move.w	d1,486(a1)
	swap	d2
	move.w	d2,640(a1)
	move.w	d2,642(a1)
	move.w	d2,644(a1)
	move.w	d2,646(a1)
	swap	d2
	move.w	d2,800(a1)
	move.w	d2,802(a1)
	move.w	d2,804(a1)
	move.w	d2,806(a1)
	swap	d3
	move.w	d3,960(a1)
	move.w	d3,962(a1)
	move.w	d3,964(a1)
	move.w	d3,966(a1)
	swap	d3
	move.w	d3,1120(a1)
	move.w	d3,1122(a1)
	move.w	d3,1124(a1)
	move.w	d3,1126(a1)
	swap	d4
	move.w	d4,1280(a1)
	move.w	d4,1282(a1)
	move.w	d4,1284(a1)
	move.w	d4,1286(a1)
	swap	d4
	move.w	d4,1440(a1)
	move.w	d4,1442(a1)
	move.w	d4,1444(a1)
	move.w	d4,1446(a1)
	swap	d5
	move.w	d5,1600(a1)
	move.w	d5,1602(a1)
	move.w	d5,1604(a1)
	move.w	d5,1606(a1)
	swap	d5
	move.w	d5,1760(a1)
	move.w	d5,1762(a1)
	move.w	d5,1764(a1)
	move.w	d5,1766(a1)
	swap	d6
	move.w	d6,1920(a1)
	move.w	d6,1922(a1)
	move.w	d6,1924(a1)
	move.w	d6,1926(a1)
	swap	d6
	move.w	d6,2080(a1)
	move.w	d6,2082(a1)
	move.w	d6,2084(a1)
	move.w	d6,2086(a1)
	swap	d7
	move.w	d7,2240(a1)
	move.w	d7,2242(a1)
	move.w	d7,2244(a1)
	move.w	d7,2246(a1)
	swap	d7
	move.w	d7,2400(a1)
	move.w	d7,2402(a1)
	move.w	d7,2404(a1)
	move.w	d7,2406(a1)
.next	
	lea	8(a1),a1
	movem.w	(sp)+,d6/d7
	dbra	d7,.loopx
	lea	160*15+(160-(TILE_COUNT_WIDTH*8))(a1),a1
	dbra	d6,.loopy
	rts
	

	section data
edit_type dc.w 0
old_edit_type dc.w 0

menu:
	incbin menu.bin
		even
type_of_tile	dc.b	0,0
pos_editor dc.w 0
	even
boot_name 
	dc.b 	"BOOT",0
	even
