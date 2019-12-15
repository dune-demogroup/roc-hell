	section text
BNK_SIZE	equ	17056-32
SPRITE_SIZE	equ 8*16
SPRITE_MSK_SIZE	equ 2*16
SPRITE_SHIFT_ANIM	equ	7
BASE_SPRITE_MSK	equ 128*SPRITE_SIZE

load_bnk:
	move.l	#picture_name,FILENAME_LOAD
	bsr	open
	move.l	#palette,LOAD_SAVE_BUF
	move.l	#32,LOAD_SAVE_LENGTH
	bsr	load
	move.l	#sprite_bnk,LOAD_SAVE_BUF
	move.l	#BNK_SIZE,LOAD_SAVE_LENGTH
	bsr	load
	bsr	close
	movem.l	palette,d0-d7
	movem.l	d0-d7,$ffff8240.w
	lea	palette,a0
	bsr settimerb1_palette
	bsr	generate_tile_code
*	bsr restore_vec
*	bsr init_vec	
	rts
	section	data
picture_name dc.b "01.BNK",0
	even
	section bss
sprite_bnk	ds.b	BNK_SIZE
	even

	section text
	IFNE RELOAD_SOUND_BANK_
reload_sound_bank:
	move.l	#sound_bank_name,FILENAME_LOAD
	bsr	open
	move.l	#sound_bank,LOAD_SAVE_BUF
	move.l	#65536,LOAD_SAVE_LENGTH
	bsr	load
	bsr	close
	rts
	section	data
sound_bank_name dc.b "SOUND.BNK",0
	even
	ENDC
	section	data
sound_bank:
	incbin "SOUND.BNK"
	IFNE	RELOAD_SOUND_BANK_
	ds.b	2048	
	ENDC
	even

*****************************************
**in:d1 -> left/top corner
*****************************************
	section text
display_map:
	IFNE	PROFILE
	move.w	#$700,$ffff8240.w
	ENDC
	lea		map,a0
	lea		map_anim,a3
	lea		(a0,d1),a0
	lea		(a3,d1),a3

	movem.l	a0/a3,-(sp)	 
	lea		dirt_around,a4
	move.l	partial_dirt,a5
	moveq	#TILE_COUNT_HEIGHT-1,d6
	lea		.gen_code_table,a6
	moveq	#0,d5
	moveq	#0,d0
	moveq	#1,d2
	moveq	#0,d4
.loop_partial_y
	moveq	#19,d7
	move	d7,d3
	swap	d3
.loop_partial_x	
	move.b	(a0)+,d0
	move.b	(a3)+,d3
	lsr		#2,d3
	cmp.b	d0,d2
	bne		.no_partial_dirt
	move.b	-2(a0),d0
	move.b	(a4,d0),d4
	add		d4,d4
	move.b	255(a0),d0
	or.b	(a4,d0),d4
	add		d4,d4
	move.b	(a0),d0
	or.b	(a4,d0),d4
	add		d4,d4
	move.b	-257(a0),d0
	or.b	(a4,d0),d4
	move.w	d5,(a5)+
	and		#3,d3
	add		d4,d4
	add		d4,d4
	or		d4,d3
	moveq	#0,d4
	move.b	d3,(a5)+
	move.b	d4,(a5)+
	addq	#8,d5
	dbra	d7,.loop_partial_x
	swap	d3
	neg		d3
	add		#MAX_MAP_X-1,d3
	add		d3,a0
	add		d3,a3
	swap	d2
	add		#160*16,d2
	move	d2,d5
	swap	d2
	dbra	d6,.loop_partial_y
	bra		.display_partial_dirt
.no_partial_dirt
	move.w	d5,(a5)+
	and.b	32(a6,d0),d3
	move.b	(a6,d0),d0
	add		d0,d3
	move.b	d3,(a5)+
	move.b	d4,(a5)+
	addq	#8,d5
	dbra	d7,.loop_partial_x
	swap	d3
	neg		d3
	add		#MAX_MAP_X-1,d3
	add		d3,a0
	add		d3,a3
	swap	d2
	add		#160*16,d2
	move	d2,d5
	swap	d2
	dbra	d6,.loop_partial_y


.display_partial_dirt
	movem.l	(sp)+,a0/a3
	move.l	screen,a1
	lea		8*160(a1),a1
	IFNE	PROFILE
	move.w	#$7,$ffff8240.w
	ENDC
	move.l	partial_dirt,a0
	sub		a0,a5
	move	a5,d7
	lsr		#2,d7
	subq	#1,d7
	bmi		.end
	moveq	#0,d2
	*bsr	restore_vec
	lea		generated_tiles,a6
	move.l	a6,usp
.loop_display_base
	move.l	a1,a2
	add.w	(a0)+,a2						8
	move.l	usp,a6
	add.w	(a0)+,a6						8
	movem.l	(a6)+,d0-d6/a3-a5				92
	movem.l	d0/d1,(a2)						24
	movem.l	d2/d3,160(a2)					24
	movem.l	d4/d5,160*2(a2)					24
	movem.l	d6/a3,160*3(a2)					24
	movem.l	a4/a5,160*4(a2)					24
	movem.l	(a6)+,d0-d6/a3-a5				92
	movem.l	d0/d1,160*5(a2)
	movem.l	d2/d3,160*6(a2)
	movem.l	d4/d5,160*7(a2)
	movem.l	d6/a3,160*8(a2)
	movem.l	a4/a5,160*9(a2)
	movem.l	(a6)+,d0-d6/a3-a5			92
	movem.l	d0/d1,160*10(a2)
	movem.l	d2/d3,160*11(a2)
	movem.l	d4/d5,160*12(a2)
	movem.l	d6/a3,160*13(a2)
	movem.l	a4/a5,160*14(a2)
	movem.l	(a6)+,d0-d4					44
	movem.l	d0/d1,160*15(a2)
	movem.l	d2/d3,160*16(a2)
	dbra	d7,.loop_display_base		12
.end

	IFNE	PROFILE
	move.w	#$0,$ffff8240.w
	ENDC
	rts
.gen_code_table
	dc.b	064,000,-05,-58,-04,-64,-07,-33
	dc.b	-06,-38,-29,-25,-08,-21,-16,-12
	dc.b	065,081,077,074,078,073,083,099
	dc.b	-127,000,000,000,000,000,000,000
	dc.b	$00,$03,$00,$1F,$00,$07,$00,$03
	dc.b	$00,$03,$07,$03,$00,$07,$03,$03
	dc.b	$07,$03,$03,$03,$03,$1F,$1F,$1F
	dc.b	$03,$00,$00,$00,$00,$00,$00,$00
	even


*************************************************
*************************************************
combine_partial_dirt_mask
	moveq	#0,d7
.loop_mask
	move	d7,d0
	and		#1,d0
	lsl		#5,d0
	move	d7,d1
	and		#2,d1
	lsl		#5,d1
	move	d7,d2
	and		#4,d2
	mulu	#8*3,d2
	move	d7,d3
	and		#8,d3
	lsl		#4,d3
	move.w	#15,d6
	move.l	a0,a2
.loop_y_mask
	move.w	(a2,d0),d4
	and.w	(a2,d1),d4
	and.w	(a2,d2),d4
	and.w	(a2,d3),d4
	lea		2(a2),a2
	move.w	d4,(a1)+
	dbra	d6,.loop_y_mask
	addq	#1,d7
	cmp		#16,d7
	bne		.loop_mask
	rts


generate_tile_code
	lea		partial_dirt_masks_combine,a1
	lea		sprite_bnk+BASE_SPRITE_MSK,a0	
	bsr		combine_partial_dirt_mask
	lea		sprite_bnk+BASE_SPRITE_MSK+SPRITE_MSK_SIZE*5,a0	
	bsr		combine_partial_dirt_mask
	lea		sprite_bnk+BASE_SPRITE_MSK+SPRITE_MSK_SIZE*10,a0	
	bsr		combine_partial_dirt_mask
	lea		sprite_bnk+BASE_SPRITE_MSK+SPRITE_MSK_SIZE*15,a0	
	bsr		combine_partial_dirt_mask

	lea		generated_tiles,a6
	lea		sprite_bnk,a2
	moveq	#TILE_COUNT_HEIGHT-1,d6
	moveq	#TILE_COUNT_HEIGHT-1,d6
	moveq	#15,d5
	moveq	#0,d4
.loop_sprites_2
	move.w	#52*SPRITE_SIZE,d0
	moveq	#3,d7
	lea	partial_dirt_masks_combine,a4
	lea	(a4,d4),a4
.loop_sprites_1
	lea		(a2,d0),a0
	moveq	#15,d6
.loop_y
	move.w	(a4),d2
	swap	d2
	move.w	(a4)+,d2
	move.l	(a0)+,d3
	and.l	d2,d3
	move.l	d3,(a6)+
	move.l	(a0)+,d3
	and.l	d2,d3
	move.l	d3,(a6)+
	dbra	d6,.loop_y
	lea		128(a6),a6
	lea		15*32(a4),a4
	add		#8*16,d0
	dbra	d7,.loop_sprites_1
	add		#32,d4
	dbra	d5,.loop_sprites_2


	moveq	#15,d6
.loop_y_clear
	clr.l	(a6)+
	clr.l	(a6)+
	dbra	d6,.loop_y_clear
	lea		128(a6),a6

V	SET		78
	REPT	21+32
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR

	
	lea		generated_tiles,a6
	lea		-256*64(a6),a6
V	SET		32
	REPT	6
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*6
V	SET		0
	REPT	16
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*22
V	SET		58
	REPT	4
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*26
V	SET		47
	REPT	5
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*31
V	SET		16
	REPT	12
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*43
	lea		38*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite

V	SET		24+38
	REPT	4
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*47
V	SET		70
	REPT	8
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
*55
	lea		45*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
	lea		56*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
	lea		57*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
	lea		38*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
	lea		39*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
*60
	lea		generated_tiles,a6
	lea		-256*127(a6),a6
V	SET		28
	REPT	4
	lea		V*SPRITE_SIZE(a2),a0
	bsr		generate_a_sprite
V	SET		V+1
	ENDR
	
	move.l	#generated_tiles,d2
	rts


generate_a_sprite:
	moveq	#15,d6
.loop_y_rock
	move.l	(a0)+,(a6)+
	move.l	(a0)+,(a6)+
	dbra	d6,.loop_y_rock
	lea		128(a6),a6
	add		#4*16,d0
	rts

	section data
	even
dirt_around
	dc.b	1,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0
	dc.b	1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
	even
	section bss
partial_dirt_masks_combine
	ds.w	4*4*16*16

	ds.b	256*128
generated_tiles
	ds.b	256*128

	section bss
map			ds.b	MAX_MAP_Y*MAX_MAP_X
map_anim	ds.b	MAX_MAP_Y*MAX_MAP_X
