MOUSE_RESTORE_BACKGROUND equ	0
play_sounds macro

	lea		sound_a,a2
	moveq	#-1,d2
	moveq	#2,d7
	moveq	#0,d4
	moveq	#0,d5
	lea		$ffff8800.W,a1
	lea		sound_bank,a0
.\@loop_sound
	move.w	(a2),d0
	beq		.\@no_sound
	lea		(a0,d0.w),a3
	move.w	4(a2),d1
	cmp.w	(a3)+,d1
	blt		.\@no_loop_sound_vol
	move.w	2(a2),d1
	tst		d1
	bge		.\@no_loop_sound_vol
	clr.w	(a2)
	move.w	6(a2),d0		
	movep	d0,(a1)
	bra		.\@no_sound
.\@no_loop_sound_vol
	lea		(a3,d1),a3
	move.b	(a3)+,d0
	asl		d5,d0
	or		d4,d0
	and.b	d0,d2
	move.w	6(a2),d0		
	move.b	(a3)+,d0	
	movep	d0,(a1)
	move	8(a2),d0		
	move.b	(a3)+,d0
	movep	d0,(a1)
	move.w	10(a2),d0	
	move.b	(a3)+,d0
	movep	d0,(a1)
	addq	#4,d1
	move.w	d1,4(a2)
.\@no_sound
	add		d4,d4
	addq	#1,d4
	addq	#1,d5
	lea		12(a2),a2
	dbra	d7,.\@loop_sound
	move.w	#$7ff,d0
	and.b	d2,d0		
	movep	d0,(a1)
	endm

stop_sounds macro
	clr.w	sound_a_cursor
	move.w	#-4,sound_a_lp
	clr.w	sound_a
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	clr.w	sound_b
	clr.w	sound_c_cursor
	move.w	#-4,sound_c_lp
	clr.w	sound_c
	endm

**********************************************
*  LES INITIALISATIONS
**********************************************
	section	text

	move.l	#pile,-(sp)
	move.w	#$20,-(sp)
	trap	#1
	move.l	d0,ssp
	bclr	#0,$484.w
	movem.l	$ffff8240.w,d0-d7
	movem.l d0-d7,oldpal
	move.b $ffff8201.w,oldscreen
	move.b $ffff8203.w,oldscreen+1
	move.b $ffff8260.w,oldres
	move.b $ffff820a.w,oldres+1
	lea	screen,a0
	movem.l	(a0),d0-d1
	clr.b	d0
	clr.b	d1
	movem.l	d0-d1,(a0)

	moveq	#0,d1
	lea		$ffff8205.w,a0
	movep.w	(a0),d1
	lsl.l	#8,d1
	move.l	d1,a0
	
	move.l	$70.w,svbl
	move.l	$118.w,skey
	clr.w	$468.w
	bsr	init_vec
	bsr	init

	bsr	prg	
	clr.w	joy_buttons	
	bsr	vsync
	move.b oldres,$ffff8260.w
	move.b oldres+1,$ffff820a.w
	move.b oldscreen,$ffff8201.w
	move.b oldscreen+1,$ffff8203.w	
	movem.l	oldpal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	bsr restore_vec
	move.l	ssp,-(sp)
	move.w	#$20,-(sp)
	trap	#1
	clr.w	-(sp)
	trap	#1

restore_vec:
	move.w	#$2700,sr
	move.b	MFP,$fffffa07.w
	move.b	MFP+1,$fffffa09.w
	move.b	MFP+2,$fffffa0F.w
	move.b	MFP+3,$fffffa11.w
	move.b	MFP+4,$fffffa13.w
	move.b	MFP+5,$fffffa15.w
	move.b	MFP+6,$fffffa1B.w
	move.b	MFP+7,$fffffa21.w

	move.l	skey,$118.w
	move.l	svbl,$70.w
	
	move.W	#$2300,sr
	bsr	clbufkey
	rts 

init_vec:
	move.w	#$2700,sr
	move.b	$fffffa07.w,MFP
	move.b	$fffffa09.w,MFP+1
	move.b	$fffffa0F.w,MFP+2
	move.b	$fffffa11.w,MFP+3
	move.b	$fffffa13.w,MFP+4
	move.b	$fffffa15.w,MFP+5
	move.b	$fffffa1B.w,MFP+6
	move.b	$fffffa21.w,MFP+7
	move.b  #1,$fffffa07.w		timerb
	move.b  #1,$fffffa13.w		timerb
	move.b  #64,$fffffa09.w		keyboard
	move.b  #64,$fffffa15.w		keyboard
	clr.b	$fffffa1b.w
	bsr	clbufkey	
	move.l	#vbl,$70.w
	move.l	#keyboard,$118.w
	move.l	#timerb,$120.w
	move.w	#$2300,sr
	rts		
	section bss
MFP	ds.b	16

**************************
* screen swapping
**************************
	section text
swap
	lea	screen,a0
	movem.l	(a0),d0-d1
	exg.l	d0,d1
	movem.l	d0-d1,(a0)
	lea		$ffff8201.w,a0
	lsr.l	#8,d1
	movep.w	d1,(a0)
	rts


********************************
********************************
	section text
vsync
	moveq	#0,d0
	move.w	nb_sync_to_wait(pc),d0
.vsync1
	cmp.w	$468.w,d0
 	bgt		.vsync1
	clr.w	$468.w
.vsync2
	tst.w	$468.w
	beq		.vsync2
	clr.w	$468.w
	rts
nb_sync_to_wait
	dc.w	0
	IFNE	NEED_MOUSE_CURSUR
mouse_display dc.w 0
	ENDC


********************************
*a0: screen
*a1: text
********************************
display_text:
	lea		font+32,a2
	moveq	#7,d2
	swap	d2
	addq	#1,d2
.loop
	moveq	#0,d0
	move.b	(a1)+,d0
	beq		.end
	move.w	d0,d1
	sub.b	#'A',d0
	bge		.ok_letter
	move.w	d1,d0
	sub.b	#"0",d0
	bge		.ok_number
	moveq	#0,d0
V	SET	0
	REPT	6
	movep.l	d0,V(a0)
V	SET		V+160
	ENDR
	add.w	d2,a0
	swap	d2
	bra		.loop
.ok_number
	add		#26,d0
.ok_letter
	move	d0,d1
	lsl		#3,d0
	lsl		#4,d1
	add		d0,d1
	lea		(a2,d1),a3
ONE_COLOR_TEXT	equ	0
	IFNE	ONE_COLOR_TEXT
v	set 	0
	rept	6
	move.b	(a3)+,d5
	or.b	(a3)+,d5
	or.b	(a3)+,d5
	or.b	(a3)+,d5
	move.b	d5,v(a0)
	move.b	d5,v+2(a0)
	move.b	d5,v+4(a0)
	move.b	d5,v+6(a0)
v 	set 	v+160
	endr
	ENDC
	IFEQ	ONE_COLOR_TEXT
v	set 	0
	rept	6
	move.l	(a3)+,d5
	movep.l	 d5,v(a0)
v 	set 	v+160
	endr
	ENDC
	add.w	d2,a0
	swap	d2
	bra		.loop
.end
	rts


********************************
********************************
scroll:
	lea		scroll_bitmap,a1
	lea		scroll_buffer,a2
	subq.b	#1,scroll_step
	bge		.go_scroll
	move.b	#7,scroll_step
	lea		scroll_text,a3
	move.w	scroll_letter,d1
	addq	#1,scroll_letter
	moveq	#0,d0
	move.b	(a3,d1),d0
	bne		.no_wrap
	move.b	(a3),d0
	moveq	#1,d1
	move.w	d1,scroll_letter
.no_wrap
	move.w	d0,d1
	sub.b	#'A',d0
	bge		.ok_letter
	move.w	d1,d0
	sub.b	#"0",d0
	bge		.ok_number
	moveq	#0,d0
V	SET	0
	REPT	12
	move.l	d0,V(a2)
V	SET	V+4
	ENDR
	bra		.go_scroll
.ok_number
	add		#26,d0
.ok_letter
	move	d0,d1
	lsl		#3,d0
	lsl		#4,d1
	add		d0,d1
	lea		font+32,a3
	lea		(a3,d1),a3
	move.b	(a3)+,(a2)
	move.b	(a3)+,12(a2)
	move.b	(a3)+,24(a2)
	move.b	(a3)+,36(a2)
	move.b	(a3)+,2(a2)
	move.b	(a3)+,14(a2)
	move.b	(a3)+,26(a2)
	move.b	(a3)+,38(a2)
	move.b	(a3)+,4(a2)
	move.b	(a3)+,16(a2)
	move.b	(a3)+,28(a2)
	move.b	(a3)+,40(a2)
	move.b	(a3)+,6(a2)
	move.b	(a3)+,18(a2)
	move.b	(a3)+,30(a2)
	move.b	(a3)+,42(a2)
	move.b	(a3)+,8(a2)
	move.b	(a3)+,20(a2)
	move.b	(a3)+,32(a2)
	move.b	(a3)+,44(a2)
	move.b	(a3)+,10(a2)
	move.b	(a3)+,22(a2)
	move.b	(a3)+,34(a2)
	move.b	(a3)+,46(a2)
.go_scroll
	moveq	#3,d6
.loop_plane
	moveq	#5,d7
.loop_y
	eor		d0,d0
	roxl	(a2)+
V	SET		160
	REPT	20
V	SET	V-8                                  
	roxl	v(a1)
	ENDR
	lea		160(a1),a1
	dbra	d7,.loop_y
	lea		-160*6+2(a1),a1
	dbra	d6,.loop_plane
	move.l	screen+4,a0
	lea		scroll_bitmap,a1
	REPT	6
	movem.l	(a1)+,d0-d7
	movem.l	d0-d7,(a0)
	movem.l	(a1)+,d0-d7
	movem.l	d0-d7,32(a0)
	movem.l	(a1)+,d0-d7
	movem.l	d0-d7,64(a0)
	movem.l	(a1)+,d0-d7
	movem.l	d0-d7,96(a0)
	movem.l	(a1)+,d0-d7
	movem.l	d0-d7,128(a0)
	lea	160(a0),a0
	ENDR
.end
	rts
copy_scroll_text:
	clr.w scroll_letter
	lea	scroll_text,a1
.loop
	move.b	(a0)+,(a1)+
	beq	.end	
	bra	.loop
.end
	move.w	#6*2+(6*160/4)-1,d7
	lea		scroll_buffer,a0
.loop_clr
	clr.l	(a0)+
	dbra	d7,.loop_clr
	rts
	section	data
scroll_letter dc.w 0
	even
	section	bss
scroll_text ds.b 1024
scroll_active ds.b 1
scroll_step ds.b 1
scroll_buffer ds.w	6*4
scroll_bitmap ds.b	6*160
	section	text
********************************
******************************** 
vbl:
	movem.l	d0-a6,-(sp)

	move.l	timerb_rout,$120.w

	move.b	#7,$fffffa21.w
	move.b	#8,$fffffa1b.w
	move.w	#-1,flagvbl
	addq.w	#1,$468.w
	addq.w	#1,vbl_counter

	moveq	#0,d1
	lea		$ffff8205.w,a0
	movep.w	(a0),d1
	lsl.l	#8,d1
	move.l	d1,a0

	IFNE	NEED_MOUSE_CURSUR
	move mouse_display(pc),d0
	beq .no_mouse
	bsr display_mouse
.no_mouse
	ENDC
	tst.b	scroll_active
	beq		.not_scroll
	bsr		scroll
.not_scroll
	play_sounds
	movem.l	(sp)+,d0-a6
	rte


	section data
timerb_rout		dc.l	timerb
vbl_counter		dc.w 0
*SOUNDS
sound_a			dc.w 0
sound_a_lp		dc.w -4
sound_a_cursor	dc.w 0
				dc.w	$800,0,$100
sound_b			dc.w 0
sound_b_lp		dc.w -4
sound_b_cursor	dc.w 0
				dc.w	$900,$200,$300
sound_c			dc.w 0
sound_c_lp		dc.w -4
sound_c_cursor	dc.w 0
				dc.w	$A00,$400,$500

	even


	section text
timerb:
	IFEQ	PROFILE
	move.l	#$07000001,$FFFFF8240.w
	ELSEIF
	move.l	#$00020003,$FFFFF8244.w
	ENDC
	move.l	#$00020003,$FFFFF8244.w
	move.l	#$00040005,$FFFFF8248.w
	move.l	#$00060007,$FFFFF824C.w
	move.l	#$01070207,$FFFFF8250.w
	move.l	#$03070407,$FFFFF8254.w
	move.l	#$05070607,$FFFFF8258.w
	move.l	#$07070717,$FFFFF825C.w
	clr.b	$fffffa1b.w
	move.b	#200-7,$fffffa21.w
	move.b	#8,$fffffa1b.w
	move.l	#timerb2,$120.w
	bclr	#0,$fffffa0F.w
	rte
*a0 : palette
settimerb1_palette:
	lea		timerb,a1
	move.l	(a0)+,2(a1)
	move.l	(a0)+,10(a1)
	move.l	(a0)+,18(a1)
	move.l	(a0)+,26(a1)
	move.l	(a0)+,34(a1)
	move.l	(a0)+,42(a1)
	move.l	(a0)+,50(a1)
	move.l	(a0)+,58(a1)
	rts
timerb2:
	IFEQ	PROFILE
	move.l	#$00070001,$FFFFF8240.w
	ELSEIF
	move.l	#$00020003,$FFFFF8244.w
	ENDC
	move.l	#$00020003,$FFFFF8244.w
	move.l	#$00040005,$FFFFF8248.w
	move.l	#$00060007,$FFFFF824C.w
	move.l	#$01070207,$FFFFF8250.w
	move.l	#$03070407,$FFFFF8254.w
	move.l	#$05070607,$FFFFF8258.w
	move.l	#$07070717,$FFFFF825C.w
	clr.b	$fffffa1b.w
	bclr	#0,$fffffa0F.w
	rte
settimerb2_palette:
	lea		timerb2,a1
	move.l	(a0)+,2(a1)
	move.l	(a0)+,10(a1)
	move.l	(a0)+,18(a1)
	move.l	(a0)+,26(a1)
	move.l	(a0)+,34(a1)
	move.l	(a0)+,42(a1)
	move.l	(a0)+,50(a1)
	move.l	(a0)+,58(a1)
	rts

	section text
clbufkey
	btst	#0,$fffffc00.w
	beq	.fin
	move.b	$fffffc02.w,d0
	bra	clbufkey
.fin
	rts
	
***************************
*interrupt keyboard
keyboard: 
	move.w	d0,-(sp)
	bclr	#6,$fffffa15.w
	btst.b	#0,$fffffc00.w
	beq		end_keyboard
	clr.w	d0
	move.b	$fffffc02.w,d0
	cmp.b	#$f8,d0
	bne		.buttons_state1
	move.l	#mousex,$118.w
	clr.b	joy_buttons
	bra		end_keyboard
.buttons_state1
	cmp.b	#$f9,d0
	bne		.buttons_state2
	move.l	#mousex,$118.w
	move.b	#2,joy_buttons
	bra		end_keyboard
.buttons_state2
	cmp.b	#$fa,d0
	bne		.buttons_state3
	move.l	#mousex,$118.w
	move.b	#1,joy_buttons
	bra		end_keyboard
.buttons_state3
	cmp.b	#$fb,d0
	bne		.isjoy
	move.l	#mousex,$118.w
	move.b	#3,joy_buttons
	bra		end_keyboard
.isjoy
	cmp.b	#$fc,d0
	blo		.key_keyboard
	cmp.b	#$ff,d0
	bne		.otherjoy
	move.l	#joy,$118.w
	bra		end_keyboard
.otherjoy
	move.l	#otherjoy,$118.w
	bra		end_keyboard
.key_keyboard
	move.b	d0,thekey
	move.l	a0,-(sp)
	lea		thekeymap,a0
	tst.b	d0
	bclr	#7,d0
	spl		(a0,d0)
	move.l	(sp)+,a0
end_keyboard	
	move.w	(sp)+,d0
	bclr	#6,$fffffa11.w
	bset	#6,$fffffa15.w
	rte


otherjoy:
	move.w	d0,-(sp)
	bclr	#6,$fffffa15.w
	btst.b	#0,$fffffc00.w
	beq		end_keyboard
	move.b	$fffffc02.w,d0
	move.l	#keyboard,$118.w
	bra		end_keyboard
joy:
	move.w	d0,-(sp)
	bclr	#6,$fffffa15.w
	btst.b	#0,$fffffc00.w
	beq		end_keyboard
	move.b	$fffffc02.w,d0
	move.b	d0,joy_directions
	move.l	#keyboard,$118.w
	bra		end_keyboard
mousex:	
	move.w	d0,-(sp)
	bclr	#6,$fffffa15.w
	btst.b	#0,$fffffc00.w
	beq		end_keyboard
	move.b	$fffffc02.w,d0
	ext.w	d0
	add.w	d0,xpt
.ok0	
	move.l	#mousey,$118.w
	bra		end_keyboard
mousey:	
	move.w	d0,-(sp)
	bclr	#6,$fffffa15.w
	btst.b	#0,$fffffc00.w
	beq		end_keyboard
	move.b	$fffffc02.w,d0
	ext.w	d0
	add.w	d0,ypt
.ok0
	move.l	#keyboard,$118.w
	bra		end_keyboard
	
********************************
*
* donn�es concernant le keyboard
*
********************************
	section	bss
	
mouse	ds.l	1
joy_states
joy_buttons	ds.b	1
joy_directions
		ds.b	1
thekey	ds.w	1
mouse_pt:
xpt		ds.w	1
ypt		ds.w	1
thekeymap ds.b	128

********************************
********************************
	section text	
cls		
	moveq	#0,d0
	moveq	#0,d1
	move.l	d0,d2
	move.l	d1,d3
	move.l	d0,d4
	move.l	d1,d5
	move.l	d0,d6
	move.w	#199,d7
	move.l	d1,a0
	move.l	d0,a1
	move.l	d1,a2
	move.l	screen,a3
.loop	
	movem.l	d0-d6/a0-a2,(a3)	0
	movem.l	d0-d6/a0-a2,40(a3)	40
	movem.l	d0-d6/a0-a2,80(a3)	80
	movem.l	d0-d6/a0-a2,120(a3)	120
	lea	160(a3),a3
	dbra	d7,.loop
	rts

*************************************
*************************************
cls1	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	move.w	#99,d7
	move.w	d0,a0
	move.w	d0,a1
	move.w	d0,a2
	move.l	screen,a3
.loop	
	movem.l	d0-d6/a0-a2,(a3)	0
	movem.l	d0-d6/a0-a2,40(a3)	40
	movem.l	d0-d6/a0-a2,80(a3)	80
	movem.l	d0-d6/a0-a2,120(a3)	120
	lea	160(a3),a3
	dbra	d7,.loop
	move.l	#$ffff0000,d0
	move.l	#0,d1
	move.l	d0,d2
	move.l	d1,d3
	move.l	d0,d4
	move.l	d1,d5
	move.l	d0,d6
	move.l	d1,a0
	move.l	d0,a1
	move.l	d1,a2
	moveq 	#99,d7
.loop1	
	movem.l	d0-d6/a0-a2,(a3)	0
	movem.l	d0-d6/a0-a2,40(a3)	40
	movem.l	d0-d6/a0-a2,80(a3)	80
	movem.l	d0-d6/a0-a2,120(a3)	120
	lea	160(a3),a3
	dbra	d7,.loop1
	rts
	IFNE	NEED_MOUSE_CURSUR	
display_mouse
	IFNE MOUSE_RESTORE_BACKGROUND
	bsr	restore_backgound
	bsr	save_backgound
	ENDC
	lea	mouse,a1
	movem.w	(a1),d0-d1
	cmp	#320-16,d0
	sge.b	d4
	move.w	d0,d2
	and.w	#$fff0,d0
	lsr.w	#1,d0
	and.w	#$f,d2
	move.l	d1,d3
	lsl		#7,d3
	lsl		#5,d1
	add		d3,d1		
	add.w	d0,d1
	lea		(a0,d1),a0
	moveq	#15,d7
	move.l	mouse_motif,a1
	move.l	mouse_mask,a2
	tst.b	d4
	bne		.loop_clip
.loop
	moveq	#0,d0
	moveq	#-1,d1
	move.w	(a1)+,d0
	move.w	(a2)+,d1
	ror.l	d2,d0
	ror.l	d2,d1
	move	d0,a3
	swap	d0
	move	d0,a4
	move	a3,d0
	move	d1,a5
	swap	d1
	move	d1,a6
	move	a5,d1
	movem.l	(a0),d3-d6
	and.l	d1,d3
	or.w	d0,d3
	and.l	d1,d4
	*or.l	d0,d4
	move	a4,d0
	swap	d0
	move	a4,d0
	move	a6,d1
	swap	d1
	move	a6,d1
	and.l	d1,d5
	or.w	d0,d5
	and.l	d1,d6
	*or.l	d0,d6
	movem.l	d3-d6,(a0)
	lea		160(a0),a0
	dbra	d7,.loop
	lea		-160*16(a0),a0
	rts
.loop_clip
	moveq	#0,d0
	moveq	#-1,d1
	move.w	(a1)+,d0
	move.w	(a2)+,d1
	ror.l	d2,d0
	ror.l	d2,d1
	move	d0,a3
	swap	d0
	move	a3,d0
	move	d1,a5
	swap	d1
	move	a5,d1
	movem.l	(a0),d3-d4
	and.l	d1,d3
	or.l	d0,d3
	and.l	d1,d4
	or.l	d0,d4
	move	a4,d0
	movem.l	d3-d4,(a0)
	lea		160(a0),a0
	dbra	d7,.loop_clip
	lea		-160*16(a0),a0
	rts
	ENDC

	IFNE	MOUSE_RESTORE_BACKGROUND
save_backgound
	lea	mouse,a0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	and.W	#$fff0,d0
	lsr	d0
	mulu	#160,d1
	add.w	d0,d1
	move.l	screenphy,a0
	add.w	d1,a0
	move.l	a0,adr_background
	moveq	#15,d7
	lea	background,a1
.loop	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	160-16(a0),a0
	dbra	d7,.loop
	rts

restore_backgound
	move.l	adr_background,a1
	moveq	#15,d7
	lea	background,a0
.loop	
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	160-16(a1),a1
	dbra	d7,.loop
	rts
	ENDC
	section data
adr_background	dc.l	0
	section	bss
background	ds.l	16*4
	section data
	IFNE	NEED_MOUSE_CURSUR
mouse_motif
	dc.l	mouse_pointer
mouse_mask
	dc.l	mouse_pointer_mask
mouse_pointer
	dc.w	%0000000000000000
	dc.w	%0110000000000000
	dc.w	%0111000000000000
	dc.w	%0111100000000000
	dc.w	%0111110000000000
	dc.w	%0111111000000000
	dc.w	%0111111100000000
	dc.w	%0111111110000000
	dc.w	%0111110000000000
	dc.w	%0110110000000000
	dc.w	%0000011000000000
	dc.w	%0000011000000000
	dc.w	%0000001100000000
	dc.w	%0000001100000000
	dc.w	%0000000110000000
	dc.w	%0000000000000000
mouse_pointer_mask
	dc.w	%0011111111111111
	dc.w	%0000111111111111
	dc.w	%0000011111111111
	dc.w	%0000001111111111
	dc.w	%0000000111111111
	dc.w	%0000000011111111
	dc.w	%0000000001111111
	dc.w	%0000000000111111
	dc.w	%0000000001111111
	dc.w	%0000000111111111
	dc.w	%1010000011111111
	dc.w	%1111000011111111
	dc.w	%1111100001111111
	dc.w	%1111100001111111
	dc.w	%1111110000111111
	dc.w	%1111111001111111
mouse_pointer_box
	dc.w	%1111111111111111
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1000000000000001
	dc.w	%1111111111111111
mouse_pointer_box_mask
	dc.w	%0000000000000000
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0111111111111110
	dc.w	%0000000000000000
	ENDC
**********************************************
* 	Donn�es g�n�rales
**********************************************

compvbl	dc.w	0
pas		dc.w	0
pas1	dc.w	0
y_bas	dc.w	0
oldrez	dC.w	0

screen	dc.l	e0
screenphy
	IFNE DEBUG
	dc.l	e0
	ENDC
	IFEQ DEBUG 
	dc.l	e1
	ENDC
flagvbl	dc.w	0
svbl	dc.l	0
skey	dc.l	0
ssp	dc.l	0
pal	dc.w	0,$720,$730,$740,$750,$47,$57,$67
	dc.w	$111,$555,$666,$444,$334,$335,$666,$777
oldpal:
	dc.w	0,$777,$777,$777
	dc.w	$777,$777,$777,$777
	dc.w	$777,$777,$777,$777
	dc.w	$777,$777,$777,$777

	section	bss
palette	ds.w	16
oldscreen ds.w 1	
oldres ds.w 1	
	ds.b	256
e0	ds.b	32000+256	
e1	ds.b	32000+256	
	ds.l	1000
pile	ds.l	100    


	section text
*************************************
*base conversion (2->10)
*************************************
*d0: number
*d7: max digits
*************************************
*a0->result
bin_to_bcd:
	add.l		d7,a0
	move.w	#0,d1
	subq	#1,d7
	move.w	d0,d1
	moveq	#10,d2
	swap	d0
.loop	
	clr.w	d0
	swap	d0
	divu	d2,d0
	swap	d0
	move.b	d0,-(a0)
	dbra	d7,.loop	
	rts

*************************************
*display a number
*************************************
*d0: number
*d7: max digits
*************************************
bindec:
	lea	bufdec,a3
	add.l	d7,a3
	move.w	#0,d1
	subq	#1,d7
	move	d7,d6
	move.w	d0,d1
	moveq	#10,d2
	swap	d0
.loop	
	clr.w	d0
	swap	d0
	divu	d2,d0
	swap	d0
	move.b	d0,-(a3)
	dbra	d7,.loop	
	move	d6,d7
	addq	#1,d7
*************************************
*a3: number (bcd)
*d7: max digits
*************************************
bindec_bcd:
	lea		font+32+26*4*6,a1
	moveq	#0,d1
	subq	#1,d7
.loop1	
	move.b	(a3)+,d0
	bne	.ras0
	tst	d1
	bne	.ras0
	tst	d7
	beq	.ras0
v	set 	0
	rept	6
	movep.l	d1,v(a0)
v 	set 	v+160
	endr
	bra	.next
.ras0	
	moveq	#-1,d1
	moveq	#0,d5
	moveq	#$f,d6
	move	d0,d5
	and		d6,d5
	move	d5,d6
	lsl		#3,d5
	lsl		#4,d6
	add		d5,d6
	lea		(a1,d6),a2
v	set 	0
	rept	6
	move.l	(a2)+,d5
	movep.l	d5,v(a0)
v 	set 	v+160
	endr
.next
	move.w	a0,d5
	btst	#0,d5
	bne		.k1
	addq.l	#1,a0
	dbra	d7,.loop1	
	rts
.k1	
	addq.l	#7,a0
	dbra	d7,.loop1
.end
	rts

	

*************************************
*display a hex
*************************************
*d0: number
*************************************
binhex:
	lea		font+32,a1
	moveq	#0,d1
	moveq	#8-1,d7
	rol.l	#4,d0
.loop1	
	move	d0,d2
	rol.l	#4,d0
	and		#$f,d2
	add		d2,d2
	move.w	.tochar(pc,d2),d2
	lea		(a1,d2),a2
v	set 	0
	rept	6
	move.l	(a2)+,d5
	movep.l	d5,v(a0)
v 	set 	v+160
	endr
	move.w	a0,d5
	btst	#0,d5
	bne		.k1
	addq.l	#1,a0
	dbra	d7,.loop1	
	rts
.k1	
	addq.l	#7,a0
	dbra	d7,.loop1
.end
	rts
.tochar dc.w	26*24,27*24,28*24,29*24
		dc.w	30*24,31*24,32*24,33*24
		dc.w	34*24,35*24,0*24,1*24,2*24
		dc.w	3*24,4*24,5*24,6*24
		even
	section	bss
bufdec		ds.b	5	
zero_bcd	ds.b	5
	section	data
one_bcd	
		dc.b 0,0,0,0,1
		even
font
	incbin	"font.bin"
	section text
*using d6/d7
random:
	move.l	rand_seed,d7
	mulu	#16807,d7
	move.w	d7,d6
	ror		#4,d7
	eor.w	d7,d6
	ror		#4,d7
	eor.w	d7,d6
	ror		#4,d7
	eor.w	d7,d6
	move.l	d7,rand_seed
	rts
rand_seed:	
	dc.l	176565874152653