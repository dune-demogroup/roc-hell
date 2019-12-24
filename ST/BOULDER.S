*****************************************
TYPE_NULL	equ	0
TYPE_BRICK	equ	2
TYPE_ANT	equ	3
TYPE_ROCK	equ	4
TYPE_DIAMOND	equ	5
TYPE_DOOR		equ 6
TYPE_FIREFLY	equ	7
TYPE_DOOR_OPEN	equ 8
TYPE_EXPLODE	equ 9
TYPE_BUTTERFLY	equ 10
TYPE_AMOEBA			equ 11
TYPE_BORDERBRICK	equ 12
TYPE_MAGIC_BRICK	equ	13
TYPE_LOCKER		equ 14
TYPE_KEY		equ 15
TYPE_BOMB		equ 16
TYPE_APPLE		equ 17
TYPE_TIME		equ 18
TYPE_HARD_ROCK	equ 19
TYPE_GEM		equ 20
TYPE_DUST		equ 21
TYPE_DEVIL1		equ 22
TYPE_DEVIL2		equ 23
TYPE_SLIME		equ 24
TYPE_MAX		equ	25

QUIT_KEY equ $1
SWAP_KEY equ $14
PLAY_KEY equ $19
LOAD_SND_BNK_KEY equ $0E
TYPE_OBJECTS_COUNT	equ	14
TYPE_OBJECTS_AND_ANIM_COUNT	equ	6

MAX_MAP_X	equ	256
MAX_MAP_Y	equ	64
MAP_MASK_Y	equ	$3FFF

		IFEQ	MASTER
DEBUG	equ	0
EDITOR	equ	1
SOUND_EDITOR equ 0
RELOAD_SOUND_BANK_ equ 1
NO_DEATH_WITH_MONSTER equ 0
PROFILE	equ	0
		ENDC
		IFNE	MASTER
DEBUG	equ	0
EDITOR	equ	0
SOUND_EDITOR equ 0
RELOAD_SOUND_BANK_ equ 0
NO_DEATH_WITH_MONSTER equ 0
PROFILE	equ	0
		ENDC
USE_KEYBOARD equ 1
		
INDESTRUCTABLE	equ	1
BINDESTRUCTABLE	equ	0
ALIVE		equ	2
BALIVE		equ	1
GRAVITY		equ	4
BGRAVITY	equ	2
DESTROY		equ	8
BDESTROY	equ	3
INPOOL_WF	equ	16
BINPOOL_WF	equ	4
NOT_LOCKER	equ	32
BNOT_LOCKER	equ	5
MAGIC		equ	64
BMAGIC		equ	6
INPOOL		equ	128
BINPOOL		equ	7

TILE_COUNT_WIDTH equ 20
TILE_COUNT_HEIGHT equ 12
NEED_MOUSE_CURSUR	equ	EDITOR

	include "INITGEN.S"
	include "FILE.S"
	include "BNK.S"
	IFNE	EDITOR
	include "EBOULDER.S"
	ENDC

	section text
intro_pic_name dc.b "intro.bin"
	even
intro_palette:
	clr.b	$fffffa1b.w
	move.b #62-7,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p62,$120.w
	bclr #0,$fffffa0f.w
	rte

.p62	move.l #$2120022,$ffff8240.w
	move.l #$320340,$ffff8244.w
	move.l #$5500760,$ffff8248.w
	move.l #$6430324,$ffff824c.w
	move.l #$4470557,$ffff8250.w
	move.l #$7630313,$ffff8254.w
	move.l #$4230533,$ffff8258.w
	move.l #$7070776,$ffff825c.w
	clr.b	$fffffa1b.w
	move.b #42,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p104,$120.w
	bclr #0,$fffffa0f.w
	rte
.p104	move.l #$2120763,$ffff8240.w
	move.l #$320340,$ffff8244.w
	move.l #$3130776,$ffff825c.w
	move.l #$7600643,$ffff8248.w
	move.l #$4370423,$ffff824c.w
	move.l #$4120632,$ffff8250.w
	move.l #$7540765,$ffff8254.w
	move.l #$6200740,$ffff8258.w
	clr.b	$fffffa1b.w
	move.b #17,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p121,$120.w
	bclr #0,$fffffa0f.w
	rte
.p121	move.l #$2120533,$ffff8240.w
	move.l #$3130423,$ffff8244.w
	move.l #$3240437,$ffff8248.w
	move.l #$5570412,$ffff824c.w
	move.l #$6320754,$ffff8250.w
	move.l #$7650740,$ffff8254.w
	move.l #$7600032,$ffff8258.w
	move.l #$3400776,$ffff825c.w
	clr.b	$fffffa1b.w
	move.b #16,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p137,$120.w
	bclr #0,$fffffa0f.w
	rte
.p137	move.l #$2120533,$ffff8240.w
	move.l #$3130423,$ffff8244.w
	move.l #$3240437,$ffff8248.w
	move.l #$3010412,$ffff824c.w
	move.l #$5100620,$ffff8250.w
	move.l #$7400750,$ffff8254.w
	move.l #$7600643,$ffff8258.w
	move.l #$5340776,$ffff825c.w
	clr.b	$fffffa1b.w
	move.b #13,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p150,$120.w
	bclr #0,$fffffa0f.w
	rte
.p150	move.l #$2120533,$ffff8240.w
	move.l #$3130423,$ffff8244.w
	move.l #$5460656,$ffff8248.w
	move.l #$7660412,$ffff824c.w
	move.l #$5100620,$ffff8250.w
	move.l #$7400436,$ffff8254.w
	move.l #$7600643,$ffff8258.w
	move.l #$5340777,$ffff825c.w
	clr.b $fffffa1b.w
	tst.b	press_p_time
	bmi		.no_text
	move.b #50-6,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p194,$120.w
	bclr #0,$fffffa0f.w
	rte
.no_text
	move.b #50,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p0,$120.w
	bclr #0,$fffffa0f.w
	rte
.p194
	move.l #$2120233,$ffff8240.w
	move.l #$3450556,$ffff8244.w
	move.l #$7660776,$ffff8248.w
	move.l #$6200740,$ffff824c.w
	move.l #$1310552,$ffff8250.w
	move.l #$7760765,$ffff8254.w
	move.l #$7550624,$ffff8258.w
	move.l #$4130212,$ffff825c.w
	clr.b $fffffa1b.w
	move.b #6,$fffffa21.w
	move.b #8,$fffffa1b.w
	move.l #.p0,$120.w
	bclr #0,$fffffa0f.w
	rte
.p0	move.l #$2120201,$ffff8240.w
	move.l #$5020613,$ffff8244.w
	move.l #$7230732,$ffff8248.w
	move.l #$6430740,$ffff824c.w
	move.l #$7500302,$ffff8250.w
	move.l #$4030313,$ffff8254.w
	move.l #$4230533,$ffff8258.w
	move.l #$3120422,$ffff825c.w
	clr.b $fffffa1b.w
	bclr #0,$fffffa0F.w
	rte





	section text
*****************************************
*SPECIFIC INITIALISATIONS
*****************************************
init:

	bsr load_bnk
	lea	font,a0
	bsr	settimerb2_palette
	IFEQ	PROFILE
	move.w	#1,nb_sync_to_wait
	ELSEIF
	clr.w	nb_sync_to_wait
	ENDC
	bsr	vsync
	clr.b	$ffff8260.w
	move.b	#2,$ffff820a.w
	bsr	random_amoeba_time
	rts		

*****************************************
*ENTRY POINT
*****************************************
menu_text
	dc.b	";GFX; <MIC< ;CODE SFX; <CORBEAU<      GREETINGS TO ALL DUNE MEMBERS :::: AND  ALL THE ATARI SCENERS ::::     ",0
	even
end_game_text
	dc.b	"; TYPE Y TO GO TO INTRO SCREEN ;; ESC TO QUIT THE GAME ;; ALL OTHER KEY CONTINUE :::::::    ",0
	even
press_p_text
	dc.b	":::: PRESS P TO PLAY ::::", 0
	even
press_p_time
	dc.b	0
	even
prg:
	clr.b	scroll_active
	IFNE	EDITOR
*MORE INFOS IN EBOULDER.S
	bsr	edit_boulder
	beq		.end
	ENDC

	IFEQ	EDITOR
	bsr		cls
	bsr		swap
	move.l	#intro_palette,timerb_rout
	move.l	#intro_pic_name,FILENAME_LOAD
	bsr	open
	move.l	screen,LOAD_SAVE_BUF
	move.l	#32000,LOAD_SAVE_LENGTH
	bsr	load
	bsr	close
	bsr vsync
	bsr	swap
	move.l	screenphy,a0
	lea		160*194+32(a0),a0
	move.l	screen,a1
	rept	6
	movem.l	(a0),d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,(a1)
	movem.l	8*4+5*4(a0),d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,8*4+5*4(a1)
	lea		160(a0),a0
	lea		160(a1),a1
	endr
	*bsr	restore_vec
.intro
	bsr vsync
	move.l	screenphy,a0
	lea		160*194+32(a0),a0
	subq.b	#8,press_p_time
	bmi		.no_text
	lea		press_p_text,a1
	bsr		display_text
	bra		.yes_text
.no_text
	move.l	screen,a1
	rept	6
	movem.l	(a1),d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,(a0)
	movem.l	8*4+4*5(a1),d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,8*4+4*5(a0)
	lea		160(a0),a0
	lea		160(a1),a1
	endr
.yes_text
	move.b	#7,$fffffa21.w
	move.b	#8,$fffffa1b.w
	bclr	#0,$fffffa0f.w

	cmp.b	#PLAY_KEY,thekey
	bne		.intro
	ENDC
.relaunch_level
	clr.b	thekey
	bsr		swap
	move.l	#timerb,timerb_rout

	bsr	prg_boulder
	IFEQ	EDITOR
	cmp.b	#QUIT_KEY,thekey
	beq		.end
	cmp.b	#SWAP_KEY,thekey
	beq		.relaunch_level
	clr		current_level
	ENDC
	bra		prg
.end
	rts

	
*****************************************
*GAME MODE
*****************************************
prg_boulder:
	
	bsr		clear_map
	bsr		loadlevel	
	bsr		makelevel
	clr.w	frame_counter
	
	lea	left_way,a3
	move.l	fireflies,a0
	move.w	#TYPE_FIREFLY,d7
	bsr	  init_monsters
	lea	right_way,a3
	move.l	butterflies,a0
	move.w	#TYPE_BUTTERFLY,d7
	bsr	init_monsters
	move.l	devils1,a0
	move.w	#TYPE_DEVIL1,d7
	bsr init_devils
	move.l	devils2,a0
	move.w	#TYPE_DEVIL2,d7
	bsr init_devils
.begin
	lea		menu_text,a0
	bsr		copy_scroll_text

	move	max_diamonds,d0
	lea		max_diamonds_bcd,a0
	moveq	#3,d7
	bsr		bin_to_bcd
	tst		current_level
	seq		scroll_active
	bsr		cls
	bsr		swap
	bsr		cls
.loop
	cmp.b	#SWAP_KEY,thekey
	beq		.level_over
	IFEQ	EDITOR
	cmp.b	#QUIT_KEY,thekey
	bne		.not_quit

	lea		end_game_text,a0
	bsr		copy_scroll_text
	st		scroll_active
.loop_end_quit_key
	bsr	vsync
	cmp.b	#QUIT_KEY,thekey
	beq		.loop_end_quit_key
	
.loop_check_quit
	bsr	vsync
	cmp.b	#QUIT_KEY,thekey
	beq		.level_over
	cmp.b	#$15,thekey
	beq		.level_over
	tst.b	thekey
	ble		.loop_check_quit
	bra		.begin
.not_quit
	ENDC

	bsr	vsync
    IFNE	PROFILE
	move.w	#7,$ffff8240.w
    ENDC

*********************************************
*CHECK INPUTS
**********************************************
	moveq	#0,d0
	move.w	joy_states,d0
	IFNE USE_KEYBOARD
	tst.b	thekeymap+$48
	beq		.nk_d
	bset 	#0,d0
.nk_d	
	tst.b	thekeymap+$50
	beq		.nk_u
	bset	#1,d0
.nk_u
	tst.b	thekeymap+$4B
	beq		.nk_l
	bset 	#2,d0
.nk_l	
	tst.b	thekeymap+$4D
	beq		.nk_r
	bset	#3,d0
.nk_r
	tst.b	thekeymap+$2A
	beq		.nk_bout
	bset	#9,d0
.nk_bout
	ENDC
	
**********************************************
*keep d0 -> input states
**********************************************
*ANIMATE THE HERO
**********************************************
	lea		map,a0
	lea		map_anim,a2
	move.w	pos_hero,d1
	and.w	#MAP_MASK_Y,d1
	lea		(a0,d1),a0
	lea		(a2,d1),a2
	move.b	#TYPE_NULL,(a0)
	move.b	anim_hero,d5
	move	d0,d1
	and.w	#$F,d1
	beq		.no_move_the_hero
 
	lea		anim_the_hero_table,a1
	moveq	#0,d4
	move.b	(a1,d1),d4
	tst		sound_c
	bne		.ok_move_the_hero
	clr.w	sound_c_cursor
	move.w	#0,sound_c_lp
	move.w	sound_bank+4,sound_c
	clr.b	idle_hero_time
	bra		.ok_move_the_hero
.no_move_the_hero
	st.b	hero_not_locked
	move.w	#-4,sound_c_lp
	clr.w	sound_c
	moveq	#16,d4
	moveq	#0,d7
	move.b	idle_hero_time,d7
	subq	#1,d7
	bcc		.no_random
	bsr		random
	and		#127,d7
	add		#128,d7
.no_random
	move.b	d7,idle_hero_time
	cmp.b	#4*8,d7
	bcs		.ok_move_the_hero	
	moveq	#0,d5
.ok_move_the_hero
	addq	#1,d5
	and.b	hero_not_locked,d5
	and		#$F,d5
	add		d4,d4
	add		d4,d4
	add		d5,d4
	move.b	d5,anim_hero

********************************************************************
*keep d0 : inputs
********************************************************************
*HERO MOVE/COLLIDES
********************************************************************
*!!!!!!!!!! FOR GAMEPLAY REASON, GAMEPLAY FRAMERATE != ANIMFRAMERATE
	move.b	d5,d7
	and.b	#1,d7
	bne		.ok_depl
	moveq	#0,d0
.ok_depl
	moveq	#1,d7
.controls	
	moveq	#0,d1
	st.b	hero_not_locked
*GO TO LEFT?
	btst	#2,d0
	beq		.hero_not_left
.not_diamant0
	cmp.b	#TYPE_ROCK,-1(a0)
	bne		.not_rock0
	tst.b	-2(a0)
	seq		hero_not_locked
	bne		.end_controls
*PUSH THE ROCK TO LEFT
	move.l	rocks,a6
	lea		-1(a0),a1	
	bsr		find_object_with_flags
	move.b	#TYPE_ROCK,-2(a0)
	move.b	#TYPE_NULL,-1(a0)
	subq.w	#1,(a6)
	btst	#9,d0
	bne		.end_controls2
	subq.b	#1,x_hero
	bra		.end_controls2
.not_rock0
	moveq	#-1,d1
	bra		.end_controls

.hero_not_left
*GO TO RIGHT?
	btst	#3,d0
	beq 	.not_right
	cmp.b	#TYPE_ROCK,1(a0)
	bne		.not_rock1
	tst.b	2(a0)
	seq		hero_not_locked
	bne		.end_controls
*PUSH THE ROCK TO RIGHT
	lea		1(a0),a1
	move.l	rocks,a6
	bsr		find_object_with_flags
	move.b	#TYPE_ROCK,2(a0)
	move.b	#TYPE_NULL,1(a0)
	addq.w	#1,(a6)
	btst	#9,d0
	bne		.end_controls2
	addq.b	#1,x_hero
	bra		.end_controls2
.not_rock1
	moveq	#1,d1
	bra		.end_controls	
.not_right
*GO TO TOP?
	btst	#0,d0
	beq		.not_top
	move.w	#$FF00,d1
	bra		.end_controls
.not_top
*GO TO BOTTOM?
	btst	#1,d0
	beq		.not_bottom
	move.w	#$100,d1
	bra		.end_controls
.not_bottom
.end_controls

	lea	(a0,d1),a0
	lea	(a2,d1),a2
	bsr	check_hero
	btst #9,d0
	bne	.end_controls2
	tst	d7
	bmi	next_level
	beq	.end_controls2
	add.w	d1,pos_hero
.end_controls2
	
	lea	map,a0
	lea	map_anim,a1
	move.w	pos_hero,d0
	and.w	#MAP_MASK_Y,d0
	move.b	#TYPE_ANT,(a0,d0)
	move.b	d4,(a1,d0)

	move.w	frame_counter,d7
	and.w	#3,d7
**********************************************************************
*LEVEL GAMEPLAY
**********************************************************************
*ROCKS/DIAMONTS/MAGIC_BRICKS/MONSTERS/AMOEBAS
***********************************************************************
*!!!!!!!!!! FOR GAMEPLAY REASON, GAMEPLAY FRAMERATE != ANIMFRAMERATE
	tst		d7
	bne		.dont_manage_this_frame1
	IFNE	PROFILE
	move.w	#$770,$ffff8240.w
	ENDC

***********************************************************************
*ROCK/DIAMONDS (gravity)
***********************************************************************
	move.l	rocks,a0
	moveq	#TYPE_ROCK,d6
	bsr		manage_gravity
	bra		.dont_manage_this_frame2
.dont_manage_this_frame1
	cmp		#1,d7
	bne		.dont_manage_this_frame2
	move.l	diamonds,a0
	moveq	#TYPE_DIAMOND,d6
	bsr		manage_gravity

***********************************************************************
*DESTROY SOMETHING (MONSTERS...)
***********************************************************************
	bsr		destroy_to

***********************************************************************
*MAGIC BRICKS
***********************************************************************
	moveq #0,d0
	bsr manage_magics	
	
***********************************************************************
*MONSTERS
***********************************************************************
	lea	left_way,a3
	move.l	fireflies,a0
	move.w	#TYPE_FIREFLY,d7
	bsr	  manage_monsters
	lea	right_way,a3
	move.l	butterflies,a0
	move.w	#TYPE_BUTTERFLY,d7
	bsr	manage_monsters

	move.l	butterflies,a0
	lea		map,a1
	move.w	(a0)+,d7
	move.l	current_destroy,a3
	move.w	#TYPE_DIAMOND,d4
	subq	#1,d7
	bmi		.no_butterflies
.loop_butterflies
	move.w	(a0),d0
	lea		4(a0),a0
	move	d0,d1
	cmp.b	#TYPE_AMOEBA,-1(a1,d0)
	beq		.destroy_butterfly
	cmp.b	#TYPE_AMOEBA,1(a1,d0)
	beq		.destroy_butterfly
	add		#256,d1
	cmp.b	#TYPE_AMOEBA,(a1,d1)
	beq		.destroy_butterfly
	sub		#512,d1
	cmp.b	#TYPE_AMOEBA,(a1,d1)
	beq		.destroy_butterfly
	dbra	d7,.loop_butterflies
	bra		.no_butterflies
.destroy_butterfly
	move.w	d0,(a3)+
	move.w	d4,(a3)+
	dbra	d7,.loop_butterflies
.no_butterflies
	move.l	a3,current_destroy

***********************************************************************
*DEVILS
***********************************************************************
	move.l	devils1,a0
	move.w	#TYPE_DEVIL1,d7
	moveq	#1,d6
	bsr	  manage_devils
	move.l	devils2,a0
	move.w	#TYPE_DEVIL2,d7
	moveq	#TYPE_NULL,d6
	bsr	manage_devils


***********************************************************************
*EXPAND AMOEBAS
**********************************************************************
	subq.b	#1,amoeba_time
	bne		.no_amoeba_event
	bsr		random_amoeba_time
	move.l	amoebas,a0
	moveq	#TYPE_AMOEBA,d5
	bsr		expand		
.no_amoeba_event



***********************************************************************
*CHECK IF DOOR NEEDS TO BE OPENED
**********************************************************************
	moveq	#0,d0
	move.w	door,d0
	lea		map,a0
	cmp.b	#TYPE_DOOR_OPEN,(a0,d0)
	beq		.check_door_end
	tst		max_diamonds
	bgt		.check_door_end
	
	clr.w	sound_b_cursor
	move.w	#-4,sound_b
	move.w	sound_bank+10,sound_b
	move.b	#TYPE_DOOR_OPEN,(a0,d0)
.check_door_end

.dont_manage_this_frame2

**********************************************************************
*LEVEL ANIMATIONS
**********************************************************************
	IFNE	PROFILE
	move.w	#$70,$ffff8240.w
	ENDC

	bsr explode_anims

**********************************************************************
*CHECK EACH VISIBLE CELL AND ANIMATE
**********************************************************************
*TODO : ?bra/bsr to type? to profile
.animvisible:
	bsr	get_displayed_map
	lea	map,a0
	lea	(a0,d1),a0
	lea	map_anim,a1
	lea	(a1,d1),a1
	moveq	#0,d2
	moveq	#TILE_COUNT_HEIGHT-1,d7
.loopanimvisible_y:
	moveq	#TILE_COUNT_WIDTH-1,d6
.loopanimvisible_x:
	move.b	(a0)+,d0
	cmp.b	#TYPE_AMOEBA,d0
	bne	.not_amoeba
	addq.b	#1,(a1)+
	moveq	#1,d2
	dbra	d6,.loopanimvisible_x	
	bra		.end_loopanimvisible_x
.not_amoeba
	cmp.b	#TYPE_SLIME,d0
	bne	.not_slime
	addq.b	#1,(a1)+
	dbra	d6,.loopanimvisible_x	
	bra		.end_loopanimvisible_x
.not_slime
	cmp.b	#TYPE_DIAMOND,d0
	bne		.not_diamond
	move.b	(a1),d1
	addq.b	#1,d1
	cmp.b	#6*4,d1
	scs		d3
	and		d3,d1
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_diamond
	cmp.b	#TYPE_MAGIC_BRICK,d0
	bne		.not_magic_brick
	move.b	(a1),d1
	beq		.not_magic_brick
	addq.b	#1,d1
	cmp.b	#(1+4)*4,d1
	blt		.dont_loop_magic_bricks	
	moveq	#1*4,d1
.dont_loop_magic_bricks
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_magic_brick
	cmp.b	#TYPE_BUTTERFLY,d0
	bne		.not_butterfly
	move.b	(a1),d1
	addq	#1,d1
	and.b	#$F,d1
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_butterfly
	cmp.b	#TYPE_FIREFLY,d0
	bne		.not_firefly
	move.b	(a1),d1
	addq	#1,d1
	and.b	#$F,d1
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_firefly
	cmp.b	#TYPE_DEVIL1,d0
	bne		.not_devil1
	move.b	(a1),d1
	move.w	d1,d3
	addq	#1,d1
	and.b	#$30,d3
	and.b	#$F,d1
	or		d3,d1
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_devil1
	cmp.b	#TYPE_DEVIL2,d0
	bne		.not_devil2
	move.b	(a1),d1
	move.w	d1,d3
	addq	#1,d1
	and.b	#$30,d3
	and.b	#$F,d1
	or		d3,d1
	move.b	d1,(a1)+
	dbra	d6,.loopanimvisible_x
	bra		.end_loopanimvisible_x
.not_devil2
	addq.l	#1,a1	
	dbra	d6,.loopanimvisible_x
.end_loopanimvisible_x
	lea	MAX_MAP_X-TILE_COUNT_WIDTH(a0),a0
	lea	MAX_MAP_X-TILE_COUNT_WIDTH(a1),a1
	dbra	d7,.loopanimvisible_y


******************************************************
*IF SOME AMOEBAS ARE VISIBLE, WE HAVE A SOUND
******************************************************
	tst	d2
	beq	.no_amoeba_sounds
	tst	sound_b
	bne .no_amoeba_sounds
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	move.w	sound_bank+12,sound_b
.no_amoeba_sounds

*****************************************************
*DISPLAY (+DEBUGDEBUG)
*****************************************************
	bsr get_displayed_map
	bsr	display_map	

	tst.b	scroll_active
	bne		.no_hud
	move.l	screen,a0
	move	max_diamonds,d0
	moveq	#3,d7
	add.l	#121,a0
	lea		font+32+37*6*4,a2
	lea		max_diamonds_bcd,a3
	cmp		#100,d0
	bge		.display_little_diamond
	subq	#1,d7
	lea		1(a3),a3
	cmp		#10,d0
	bgt		.display_little_diamond
	subq	#1,d7
	lea		1(a3),a3
.display_little_diamond
V	SET		0
	REPT	6
	move.l	(a2)+,d5
	movep.l	d5,V(a0)
V 	set 	V+160
	ENDR
	lea		7(a0),a0
	moveq	#0,d1
V	SET		0
	REPT	6
	move.l	d1,V(a0)
	move.l	d1,V+4(a0)
	move.l	d1,V+8(a0)
	move.l	d1,V+12(a0)
V 	set 	V+160
	ENDR

	tst.w	d0
	bge		.diamonds_ok
	lea		zero_bcd,a3
.diamonds_ok
	bsr	bindec_bcd

	IFEQ MASTER
	move.w	$468.w,d0
	move.l	screen,a0
	move.w	#1,d7
	add.l	#64,a0
	bsr	bindec	
	ENDC
.no_hud
	IFNE	PROFILE
	move.w	#$0,$ffff8240.w
	ENDC

********************************************************************************
*END FRAME
********************************************************************************
	bsr	swap
	addq	#1,frame_counter
	tst.b	hero_is_dead
	bne	hero_death
	bra	.loop
.level_over
********************************************************************************
*LEVEL OVER
********************************************************************************
	IFNE	EDITOR
next_level:
	ENDC
	stop_sounds
	bsr	vsync
	rts

*****************************************
*****************************************
	IFEQ	EDITOR
next_level:
	clr.w	sound_c_cursor
	move.w	#-4,sound_c_lp
	move.w	sound_bank+8,sound_c
	moveq	#20,d7
.loop	
	move.w	d7,-(sp)
	bsr	vsync
	bsr		destroy_to
	move.l	fireflies,a0
	bsr	  anim_monsters
	move.l	butterflies,a0
	bsr	anim_monsters
	bsr explode_anims
	bsr get_displayed_map
	bsr	display_map	
	bsr	swap	
	move.w	(sp)+,d7
	dbra d7,.loop
	addq	#1,current_level
	bra	prg_boulder
	ENDC
*****************************************
*HERO GAMEPLAY STATES
*****************************************
*****************************************
*d0:control states
*a0/a2:tile to check/animed tile
*d7:result: -1 next level, 0: nothing special, 1: get/open something
check_hero:
	moveq	#0,d7
	move.b	(a0),d7
	btst	#9,d0
	beq		.not_locked
	clr.b	hero_not_locked
	bra	.continue
.not_locked
	cmp.b	#TYPE_DOOR_OPEN,d7
	bne	.continue
	moveq	#-1,d7
	rts
.continue
	cmp.b	#TYPE_DIAMOND,d7
	bne	.not_diamond
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	move.w	sound_bank,sound_b

	move.l	diamonds,a6
	move.l	a6,a5
	move.l	a0,a1
	bsr		find_object_with_flags
	bne		.dont_delete
	bsr		delete_swap_with_flags
.dont_delete
	move.l	diamonds,a6
	subq	#1,max_diamonds
	move	#$04,CCR
	lea		max_diamonds_bcd+3,a6	
	lea		one_bcd+5,a5
	sbcd	-(a5),-(a6)	
	sbcd	-(a5),-(a6)	
	sbcd	-(a5),-(a6)	
	move.w	#$F0F,d7
	and.w	d7,(a6)+
	and.b	d7,(a6)+
	moveq	#1,d7	
	clr.b (a0)
	rts
.not_diamond	
	cmp.b	#TYPE_KEY,d7
	bne		.not_key
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	move.w	sound_bank,sound_b
	moveq	#0,d7
	move.b	(a2),d7
	lsr.w	#2,d7
	lea		keys_inventory,a3
	addq.b	#1,(a3,d7)
	moveq	#1,d7	
	clr.b	(a0)
	rts
.not_key	
	cmp.b	#TYPE_LOCKER,d7
	bne		.not_locker
	moveq	#0,d7
	moveq	#0,d6
	move.b	(a2),d6
	lsr.w	#2,d6
	lea		keys_inventory,a3
	tst.b	(a3,d6)
	beq		.dont_possess_the_key
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	move.w	sound_bank,sound_b
	subq.b	#1,(a3,d6)
	moveq	#1,d7	
	clr.b	(a0)
.dont_possess_the_key
	clr.b	hero_not_locked
	rts
.not_locker
	lea		type_flags,a6
	move.b	(a6,d7),d7
	btst	#BNOT_LOCKER,d7
	bne		.ok
	clr.b	hero_not_locked
	moveq	#0,d7
	rts
.ok	
	moveq	#1,d7	
	clr.b	(a0)
	rts

************************************************************
***********************************************************
hero_death:
	clr.w	sound_c_cursor
	move.w	#-4,sound_c_lp
	move.w	sound_bank+6,sound_c
	moveq	#20,d7
.loop	
	move.w	d7,-(sp)
	bsr	vsync
	bsr		destroy_to
	move.l	fireflies,a0
	bsr	  anim_monsters
	move.l	butterflies,a0
	bsr	anim_monsters
	bsr explode_anims
	bsr get_displayed_map
	bsr	display_map	
	bsr	swap	
	move.w	(sp)+,d7
	dbra d7,.loop
	clr.b	hero_is_dead 
	bra	prg_boulder

get_displayed_map:
	move.w	pos_hero,d1
	sub.b	#10,d1
	bcc	.okclx
	eor.b	d1,d1
.okclx	
	sub.w	#6*256,d1
	bcc	.okcly
	and	#$ff,d1
.okcly
	move.w level_limit,d0
	cmp.b	d0,d1
	bcs	.okclx0
	move.b	d0,d1
.okclx0	
	cmp.w	d0,d1
	bcs	.okcly0
	and.w	#$ff,d1
	and.w	#$ff00,d0
	or d0,d1
.okcly0	
	and.w	#MAP_MASK_Y,d1
	rts


*****************************************
*AMOEBAS
*****************************************
random_amoeba_time:
	bsr	random
	and	#$7F,d6
	add	#64,d6
	move.b	d6,amoeba_time
	rts



expand_at MACRO
	lea	(a1,d0),a4
	move.b	(a4),d1
	move.b	(a5,d1),d1
	btst	#BNOT_LOCKER,d1
	beq	.\@
	move.b	d5,(a4)
	move.w	d0,(a3)+
	addq	#1,d6
.\@	
	ENDM

expand:
	lea		map,a1
	lea		type_flags,a5
	move.l	a0,a2
	move.w	(a0)+,d7
	subq	#1,d7
	bmi		.end
	move.w	d7,d1
	add		d1,d1
	lea		2(a0,d1),a3
	moveq	#0,d1
	moveq	#0,d6
.loop
	move.w	(a0)+,d0
	add	#-MAX_MAP_X,d0
	expand_at		
	add	#MAX_MAP_X-1,d0
	expand_at		
	addq	#2,d0
	expand_at		
	add	#MAX_MAP_X-1,d0
	expand_at		
.next
	dbra	d7,.loop
	tst		d6
	bne		.dont_transform
	clr.w	(a2)
	move.l	diamonds,a0
	move.w	(a0),d0
	add		d0,d0
	add		d0,d0
	lea		2(a0,d0),a1
	moveq	#0,d1
	lea		map,a2
	move.w	#MAX_MAP_X*MAX_MAP_Y-1,d7
.loop_to_diamonds
	cmp.b	#TYPE_AMOEBA,(a2,d7)
	bne		.next_transform
	addq	#1,d1
	move.b	#TYPE_DIAMOND,(a2,d7)
	move	d7,(a1)+
	move.b	d1,(a1)+
	clr.b	(a1)+
.next_transform
	dbra	d7,.loop_to_diamonds
	add		d1,(a0)
	clr.w	amoebas_count
	rts
.dont_transform
	add		d6,amoebas_count

	cmp		#200,amoebas_count
	blt		.not_to_rock
	clr.w	(a2)
	move.l	rocks,a0
	move.w	(a0),d0
	add		d0,d0
	add		d0,d0
	lea		2(a0,d0),a1
	moveq	#0,d1
	lea		map,a2
	move.w	#MAX_MAP_X*MAX_MAP_Y-1,d7
	moveq	#0,d1
	lea		map,a2
	move.w	#MAX_MAP_X*MAX_MAP_Y-1,d7
.loop_to_rocks
	cmp.b	#TYPE_AMOEBA,(a2,d7)
	bne		.next_rocks
	addq	#1,d1
	move.b	#TYPE_ROCK,(a2,d7)
	move	d7,(a1)+
	move.b	d1,(a1)+
	clr.b	(a1)+
.next_rocks
	dbra	d7,.loop_to_rocks
	add		d1,(a0)
	clr.w	amoebas_count
	rts

.not_to_rock
	lea		2(a2),a1
	moveq	#0,d0
.shift:	
	cmp.l	a0,a3
	beq		.endshift
	move.w	(a0)+,(a1)+
	addq	#1,d0
	bra		.shift
.endshift
	move.w	d0,(a2)
.end
	rts
	

*****************************************
*DESTRUCTIBLES
*****************************************
destroy_to:
	lea	map,a0
	move.l	current_destroy,a3
	lea		destroy_list,a5
	move	destroy_list_idx,d0
	lea		(a5,d0),a4
	eor		#$200,d0
	lea		(a5,d0),a5
	move	d0,destroy_list_idx
	move.l	a5,current_destroy

	lea		type_flags,a5
	cmp.l	a4,a3	
	beq		.end
	clr.w	sound_b_cursor
	move.w	#-4,sound_b_lp
	move.w	sound_bank+6,sound_b
.loop
	cmp.l	a4,a3
	beq		.end
	move.w	(a4)+,d0
	move.w	(a4)+,d4
	moveq	#0,d1
	lea		(a0,d0),a1
	move.b	(a1),d1
	lea		type_flags,a5
	move.b	(a5,d1),d2
	
	btst	#BINDESTRUCTABLE,d2
	bne		.no_destroy
	move.b	d4,(a1)
	lea		type_corres,a2	
	add		d4,d4
	add		d4,d4
	move.l	(a2,d4),a2
	cmp.w	#-1,a2
	beq		.not_cumulate
	lea		map_anim,a6
	clr.b	(a6,d0)
	move.l	(a2),a2	
	cmp.w	#-1,a2
	beq		.not_cumulate
	move.w	(a2),d3
	addq	#1,(a2)
	add.w	d3,d3
	add.w	d3,d3
	move.w	d0,2(a2,d3)
	cmp.w	#TYPE_DIAMOND*4,d4
	bne		.not_diamond
	move.w	d3,4(a2,d3)
	bra		.not_cumulate
.not_diamond
	clr.w	4(a2,d3)
.not_cumulate
	btst	#BDESTROY,d2
	beq		.ennemy_not_dead	
	movem.l	a3/a4,-(sp)
	lea		type_on_destroy,a4
	moveq	#0,d4
	move.w	d0,d3
	move.b	(a4,d1),d4
	bsr		destroy_at
	movem.l	(sp)+,a3/a4
.ennemy_not_dead	
	btst	#BALIVE,d2
	bne		.death
	btst	#BINPOOL_WF,d2
	beq		.check_pool2
	lea		type_corres,a6
	add		d1,d1
	add		d1,d1
	move.l	(a6,d1),a6
	move.l	(a6),a6
	move.l	a6,a5
	bsr		find_object_with_flags
	bne		.loop
	bsr		delete_swap_with_flags
	bra		.loop
.check_pool2
	btst	#BINPOOL,d2
	beq		.no_destroy
	lea		type_corres,a6
	add		d1,d1
	add		d1,d1
	move.l	(a6,d1),a6
	move.l	(a6),a6
	move.l	a6,a5
	bsr		find_object
	bne		.loop
	bsr		delete_swap
	bra		.loop
.death
	st		hero_is_dead	
.no_destroy
	bra		.loop
.end	
	rts

*d1,d3,d4
*a3,a4
destroy_at
	move.l	current_destroy,a3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	sub	#MAX_MAP_X+1,d3
	and	#MAP_MASK_Y,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	addq	#1,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	addq	#1,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	add	#MAX_MAP_X-2,d3
	and	#MAP_MASK_Y,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	addq	#2,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	add	#MAX_MAP_X-2,d3
	and	#MAP_MASK_Y,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	addq	#1,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	addq	#1,d3
	move.w	d3,(a3)+
	move.w	d4,(a3)+
	move.l	a3,current_destroy
	rts

*****************************************
*ITEMS WITH GRAVITY (like rocks, diamonds...)
*****************************************
*a0: list of items (rocks, diamonts...)
*d6: item type
***************************************
*-> update the destroyed items list
*-> update the map
*-> update hero_death flag
*****************************************
manage_gravity:
	move.w	(a0)+,d0
	*lsr	#1,d0
	move.w	pos_hero,d5
	sub.w	#$2020,d5
	swap	d6
	move.w	#$C0C0,d6
	lea	type_flags,a5
	lea	type_on_destroy,a4
	move	d0,d1
	add		d1,d1
	add		d1,d1
	lea		(a0,d1),a6
	subq	#1,d0
	bmi	.end
	lea	map,a1
	moveq	#0,d1
	move.l	a0,-(sp)
	move.l	current_magic,a3
	move.l	current_destroy,a4
.loop
	move.w	(a0)+,d1
	move.w	d1,d2
	sub		d5,d2
	and		d6,d2
	beq		.cas0
	addq.l	#2,a0
	dbra	d0,.loop
	bra		.end_loop
.cas0
	lea		(a1,d1),a2
	add		#MAX_MAP_X,d1
	move.b	(a1,d1),d7
	addq.l	#1,a0
	cmp		#1,d7
	bne		.cas1
	clr.b	(a0)+
	dbra	d0,.loop
	bra		.end_loop
	
.cas1
	move.b	(a5,d7),d2
	tst.b	(a0)
	beq		.nottodestroy
	btst	#BALIVE,d2
	beq		.pasdead0
	st		hero_is_dead
.pasdead0
	btst	#BDESTROY,d2
	beq		.ennemypasdead
	move.w	d1,(a4)+
	clr.w	(a4)+
	move.b	#1,(a0)+
	bra		.suivante
.ennemypasdead
	btst	#BMAGIC,d2
	beq		.not_magic
	move	d1,d3
	add		#MAX_MAP_X,d1
	and		#MAP_MASK_Y,d1
	
	move.w	d1,(a3)+
	swap	d6
	move.b	d6,(a3)+
	swap	d6
	move.b	d7,(a3)+
	addq.l	#1,a0
	clr.b	(a2)
	move.l	-(a6),-(a0)
	bra		.suivante
.not_magic
.nottodestroy
	tst.b	d7
	bne		.cas2
	move.b	#TYPE_NULL,(a2)
	move.w	d1,-3(a0)
	swap	d6
	move.b	d6,(a1,d1)
	swap	d6
	move.b	#1,(a0)+
	bra		.suivante
.cas2	
	btst	#BGRAVITY,d2
	beq		.cas4
	tst.b	-1(a2)
	bne		.cas3
	tst.b	255(a2)
	bne		.cas3
	move.b	#TYPE_NULL,(a2)
	add.w	#-1,-3(a0)
	swap	d6
	move.b	d6,-1(a2)
	swap	d6
	move.b	#1,(a0)+
	bra		.suivante
.cas3	
	tst.b	1(a2)
	bne		.cas4
	tst.b	257(a2)
	bne		.cas4
	move.b	#TYPE_NULL,(a2)
	add.w	#1,-3(a0)
	swap	d6
	move.b	d6,1(a2)
	swap	d6
	move.b	#1,(a0)+
	bra		.suivante
.cas4	
	tst.b	(a0)+
	beq		.suivante
	clr.w	sound_a_cursor
	move.w	#-4,sound_a_lp
	move.w	sound_bank+2,sound_a
	clr.b	-1(a0)
.suivante
	dbra	d0,.loop
.end_loop
	move.l	a4,current_destroy
	move.l	(sp)+,a0
	move.l	a6,d0
	sub.l	a0,d0
	lsr		#2,d0
	move	d0,-2(a0)

	lea		map_anim,a1
	move.l	current_magic,a0
.loop_magic
	cmp.l	a3,a0
	beq		.end_loop_magic
	move.w	(a0),d3
	sub.w	#256,d3
	lea		4(a0),a0
	move.b	#1*4,(a1,d3)	
	bra		.loop_magic
.end_loop_magic
	move.l	a3,current_magic
.end	
	rts
	
**********************************************************
*EXPLOSIONS
**********************************************************
explode_anims:
	move.l	explodes,a0
	lea		map_anim,a1
	lea		map,a2
	move.l	a0,a5
	move.w	(a0)+,d7
	move	d7,d6
	add		d6,d6
	add		d6,d6
	lea		(a0,d6),a4
	subq	#1,d7
	bmi		.no_explode_anim
.explode_anim
	moveq	#0,d0
	move.w	(a0),d0
	addq	#4,a0
	cmp.b	#TYPE_EXPLODE,(a2,d0)
	beq		.ok_explode
	move.l	-(a4),-(a0)
	subq	#1,(a5)
	dbra	d7,.explode_anim
	rts
.ok_explode
	move.b	(a1,d0),d1
	addq.b	#2,d1
	cmp.b	#10*2,d1
	bne		.explode_notfinished
	clr.b	(a2,d0)
	move.l	-(a4),-(a0)
	clr.b	(a1,d0)
	subq	#1,(a5)
	dbra	d7,.explode_anim
	rts
.explode_notfinished
	move.b	d1,(a1,d0)
	dbra	d7,.explode_anim
.no_explode_anim
	rts




*****************************************
*MONSTERS
*****************************************


*****************************************
*a0: MONSTER LIST
*a2: flags
*d7: MONSTERS TYPE
*****************************************
*****************************************
*****************************************
anim_monsters:
	lea	map_anim,a4
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop
	move.w	(a0)+,d1
	lea		2(a0),a0
	move.b	(a4,d1),d4
	addq	#1,d4
	and.b	#$F,d4
	move.b	d4,(a4,d1)
	dbra	d0,.loop
.end
	rts


CHK_MONSTER_MACRO MACRO
	and.w	#$6,d2
	move.w	(a3,d2),d3
	add.w	d1,d3
	cmp.b	#TYPE_ANT,(a1,d3)
	beq		.death	
	tst.b	(a1,d3)
	bne		.\@nextway
	move.b	#TYPE_NULL,(a1,d1)
	move.b	d7,(a1,d3)
	move.b	(a4,d1),d4
	move.b	d4,(a4,d3)
	move.w	d3,-4(a0)
	move.b	d2,-2(a0)
	move.b	d5,-1(a0)
	bra	.next
.\@nextway
	ENDM

manage_monsters:
	lea	map,a1
	lea	map_anim,a4
	moveq	#0,d2
	moveq	#0,d5
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop	
	move.w	(a0)+,d1
	move.b	(a0)+,d2
	move.b	(a0)+,d5
	sub.b	d5,d2
	moveq	#2,d5
	CHK_MONSTER_MACRO
	moveq	#2,d5
	addq	#2,d2
	CHK_MONSTER_MACRO
	addq	#2,d2
	CHK_MONSTER_MACRO
	addq	#2,d2
	CHK_MONSTER_MACRO
	
.next
	dbra	d0,.loop
.end	
	rts
.death
	IFEQ	NO_DEATH_WITH_MONSTER
	move.b	#TYPE_EXPLODE,(a1,d3)
	clr.b	(a4,d3)

	lea	current_destroy,a4
	move.l	(a4),a3
	move.w	d3,(a3)+
	move.w	#TYPE_EXPLODE,(a3)+
	move.l	a3,(a4)
	st	hero_is_dead
	ENDC
	IFNE	NO_DEATH_WITH_MONSTER
	dbra	d0,.loop	
	ENDC
	rts


INIT_MONSTER_MACRO MACRO
	and.w	#$6,d2
	move.w	(a3,d2),d3
	add.w	d1,d3
	tst.b	(a1,d3)
	beq		.\@nextway
	addq	#2,d2
	move.b	d2,(a0)+
	move.b	d5,(a0)+
	bra	.next
.\@nextway
	ENDM


init_monsters:
	lea	map,a1
	moveq	#0,d2
	moveq	#0,d5
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop	
	move.w	(a0)+,d1
	move	d0,d2
	add		d2,d2
	moveq	#0,d5
	INIT_MONSTER_MACRO
	moveq	#2,d5
	addq	#2,d2
	INIT_MONSTER_MACRO
	addq	#2,d2
	INIT_MONSTER_MACRO
	addq	#2,d2
	INIT_MONSTER_MACRO
	addq	#2,d2
	move.b	d2,(a0)+
	move.b	d5,(a0)+
.next
	dbra	d0,.loop
.end	
	rts

*****************************************
*DEVILS
*****************************************
anim_devils:
	lea	map_anim,a4
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop
	move.w	(a0)+,d1
	lea		2(a0),a0
	move.b	(a4,d1),d4
	addq	#1,d4
	and.b	#$F,d4
	move.b	d4,(a4,d1)
	dbra	d0,.loop
.end
	rts


manage_devils:
	lea	map,a1
	lea	map_anim,a4
	lea random_march,a5
	lea	devil_way,a3

	moveq	#0,d2
	moveq	#0,d5
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop	
	move.w	(a0)+,d1
	move.w	(a0),d2
	move	d2,d4
	subq	#4,d4
	move	d4,(a0)+
	move	d4,d3
	and		#12,d3
	cmp		#12,d3
	bne		.same_dir
	lsr		#4,d2
	addq	#1,d2
	and.w	#1023,d2
	move.b	(a5,d2),d4
	and.b	#$F,d4
	lsl		#4,d2
	or.b	d4,d2
	move.w	d2,-2(a0)
	move.b	(a4,d1),d3
	and		#3,d4
	lsl		#4,d4
	and		#$F,d3
	or		d3,d4
	move.b	d4,(a4,d1)
.same_dir
	move.w	d2,d4
	and.w	#3,d2
	add		d2,d2
	move.w	(a3,d2),d3
	add.w	d1,d3
	cmp.b	#TYPE_ANT,(a1,d3)
	beq		.death	
	cmp.b	#1,(a1,d3)
	bgt		.collide
	move.b	d6,(a1,d1)
	move.b	d7,(a1,d3)
	move.b	(a4,d1),d1
	move.b	d1,(a4,d3)
	move.w	d3,-4(a0)
	dbra	d0,.loop
	bra		.end
.collide
	and.b	#$F3,d4
	move.w	d4,-2(a0)
	dbra	d0,.loop
.end	
	rts
.death
	IFEQ	NO_DEATH_WITH_MONSTER
	move.b	#TYPE_EXPLODE,(a1,d3)
	clr.b	(a4,d3)

	lea	current_destroy,a4
	move.l	(a4),a3
	move.w	d3,(a3)+
	move.w	#TYPE_EXPLODE,(a3)+
	move.l	a3,(a4)
	st	hero_is_dead
	ENDC
	IFNE	NO_DEATH_WITH_MONSTER
	dbra	d0,.loop	
	ENDC
	rts


init_devils:
	move.w	current_rmarch,d3
	lea	map,a1
	moveq	#0,d2
	moveq	#0,d5
	move.w	(a0)+,d0
	subq.w	#1,d0
	bmi	.end
.loop	
	move.w	(a0)+,d1
	move	d3,d4
	lsl		#4,d4
	move.w	d4,(a0)+
	addq	#7,d3
	and		#1023,d3
	dbra	d0,.loop
.end	
	move.w	d3,current_rmarch
	rts
current_rmarch
	dc.w	0
random_march
	incbin	r_march.bin
*****************************************
*MAGIC BRICKS
*****************************************
manage_magics:
	lea		map,a1
	lea		magic_list,a0
	lea		type_corres,a3
	move.l	current_magic,d7
	lea		transform_table,a5
	move.l	a0,a2
.loop
	cmp.l	a0,d7
	beq		.end
	move.w	(a0)+,d1
	moveq	#0,d2
	move.b	(a0)+,d2
	move.b	(a0)+,d3
	tst.b	(a1,d1)
	bne		.not_empty
	cmp.b	#TYPE_MAGIC_BRICK,d3
	bne		.not_magic_brick
	move.b	(a5,d2),d2
.not_magic_brick
	move.b	d2,(a1,d1)
	add		d2,d2
	add		d2,d2
	move.l	(a3,d2),a4
	move.l	(a4),a4
	move.w	(a4),d3
	addq	#1,(a4)+
	add		d3,d3
	add		d3,d3
	lea		(a4,d3),a4
	move.w	d1,(a4)+
	clr.w	(a4)+
	bra		.next
.not_empty
	move.w	d1,(a2)+
	move.b	d2,(a2)+
	move.b	d3,(a2)+
.next
	bra		.loop
.end
	move.l	a2,current_magic
	rts


*****************************************
*SOME HELPERS
*****************************************
find_object:
	move.l	a1,d6
	sub.l	#map,d6
	move.w	(a6)+,d7
	subq	#1,d7
	bmi	.end
.loop
	cmp.w	(a6)+,d6
	dbeq	d7,.loop
	subq.l	#2,a6
.end
	rts
	
find_object_with_flags:
	move.l	a1,d6
	sub.l	#map,d6
	move.w	(a6)+,d7
	subq	#1,d7
	bmi		.end
.loop
	cmp.w	(a6),d6
	addq.l	#4,a6
	dbeq	d7,.loop
	subq.l	#4,a6
.end
	rts

delete_swap:
	move.w	(a5),d7
	subq	#1,d7
	move	d7,(a5)+
	add	d7,d7
	move.w	(a5,d7),(a6)
	rts

delete_swap_with_flags:
	move.w	(a5),d7
	subq	#1,d7
	move	d7,(a5)+
	add	d7,d7
	add	d7,d7
	move.l	(a5,d7),(a6)
	rts
	
delete_shift:
	subq	#1,d7
	bmi	.end
.loop	
	move.w	2(a6),(a6)+
	dbra	d7,.loop
.end	
	subq	#1,(a5)
	rts

delete_shift_with_flags:
	subq	#1,d7
	bmi	.end
.loop	
	move.l	4(a6),(a6)+
	dbra	d7,.loop
.end
	subq	#1,(a5)
	rts



*****************************************************
*GAME STATES
****************************************************
	section data
left_way	
	dc.w	1,MAX_MAP_X,-1,-MAX_MAP_X
right_way	
	dc.w	-1, MAX_MAP_X,1,-MAX_MAP_X
devil_way	
	dc.w	-1,MAX_MAP_X,-MAX_MAP_X,1
*****************************************
*****************************************
*****************************************
*****************************************
*****************************************
*****************************************
	section data
frame_counter	dc.w	1
current_level	dc.w	0
level_limit	dc.b MAX_MAP_Y-12,MAX_MAP_X-20
diamonds_sup_count dc.b 0
namesave	
	dc.b	"002.LVL",0


	section	data
type_flags	dc.b	NOT_LOCKER,NOT_LOCKER,GRAVITY,ALIVE+DESTROY
			dc.b	INPOOL_WF+GRAVITY,INPOOL_WF+GRAVITY,INDESTRUCTABLE,INPOOL_WF+DESTROY
			dc.b	INDESTRUCTABLE,0,INPOOL_WF+DESTROY,INPOOL
			dc.b	INDESTRUCTABLE,INDESTRUCTABLE+MAGIC,INDESTRUCTABLE,INDESTRUCTABLE
			dc.b	INDESTRUCTABLE,INDESTRUCTABLE,INPOOL_WF+DESTROY,INPOOL_WF+DESTROY
			dc.b	INPOOL,INDESTRUCTABLE,INDESTRUCTABLE,INDESTRUCTABLE
			dc.b	INDESTRUCTABLE+MAGIC,INDESTRUCTABLE,INDESTRUCTABLE,INDESTRUCTABLE
			dc.b	INDESTRUCTABLE,INDESTRUCTABLE,INDESTRUCTABLE,INDESTRUCTABLE
					
type_on_destroy	dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_EXPLODE
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_EXPLODE
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_DIAMOND,TYPE_NULL
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_NULL
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_ROCK,TYPE_NULL
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_NULL
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_NULL
				dc.b	TYPE_NULL,TYPE_NULL,TYPE_NULL,TYPE_NULL
	even

type_corres:
	dc.l	-1,-1,-1,-1
	dc.l	rocks,diamonds,-1,fireflies
	dc.l	-1,explodes,butterflies,amoebas
	dc.l	-1,-1,-1,-1
	dc.l	-1,-1,devils1,devils2
	dc.l	slimes,-1,-1,-1
	dc.l	-1,-1,-1,-1
	dc.l	-1,-1,-1,-1

transform_table
	dc.b	0,0,0,0
	dc.b	TYPE_DIAMOND,TYPE_ROCK,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0
	dc.l	0,0,0,0

keys_inventory	dc.b	0,0,0,0

current_version
	dc.w	$8008
loaded_version
	dc.w	0

	section bss

door	ds.w	1	
	section data
hero_not_locked 
	dc.b	-1
idle_hero_time
	dc.b	0
pos_hero:
y_hero:
	dc.b	100
x_hero:
	dc.b	10	
anim_hero	
	dc.b	0
anim_the_hero_table 
	dc.b 1*4,2*4,1*4,2*4 0000 0001 0010 0011 
	dc.b 0*4,0*4,0*4,0*4 0100 0101 0110 0111
	dc.b 3*4,3*4,3*4,3*4 1000 1001 1010 1011 
	dc.b 3*4,3*4,3*4,3*4 1100 0101 0110 0111

hero_is_dead	dc.b	0
amoeba_time	dc.b	0
	even	
current_destroy	dc.l	destroy_list
current_destroy_point	dc.l	destroy_list
destroy_list_idx dc.w 0
current_magic dc.l	magic_list

	section	bss
magic_list		ds.w	512

destroy_list	ds.w	1024
destroy_point_list	ds.w	32
max_diamonds	ds.w	1
max_diamonds_bcd
				ds.b	8
null_type	ds.l	1
bricks	ds.l	1
rocks		ds.l	1
fireflies	ds.l	1
butterflies	ds.l	1
diamonds	ds.l	1
explodes	ds.l	1
amoebas	ds.l	1
amoebas_count	ds.w 1
slimes	ds.l	1
borderbricks	ds.l	1
magic_bricks	ds.l	1
times			ds.l	1
dusts			ds.l	1
lockers			ds.l	1
keys			ds.l	1
bombs			ds.l	1
apples			ds.l	1
hard_rocks		ds.l	1
gems			ds.l	1
devils1			ds.l	1
devils2			ds.l	1
partial_dirt	ds.l	1
objects		ds.w	MAX_MAP_Y*MAX_MAP_X





	section	text
****************************************
*LEVEL LOADING/MAKE/CLEAR
*****************************************
loadlevel:
	moveq	#0,d0
	move.w	current_level,d0
	moveq	#10,d2
v	SET		2
	REPT	3
	divu	d2,d0
	swap	d0
	add		#48,d0
	move.b	d0,namesave+v
	move.w	#0,d0
	swap	d0
v	SET		v-1
	ENDR
	
	move.l	#namesave,FILENAME_LOAD
	bsr	open
	bge	.present
.notgood
	bsr	close
	lea	objects,a2
	clr.l	objects
	move.l	a2,null_type	
	clr.w	(a2)+
	move.l	a2,bricks
	clr.w	(a2)+
	move.l	a2,rocks
	clr.w	(a2)+
	move.l	a2,bricks
	clr.w	(a2)+
	move.l	a2,fireflies
	clr.w	(a2)+
	move.l	a2,butterflies
	clr.w	(a2)+
	move.l	a2,diamonds
	clr.w	(a2)+
	move.l	a2,amoebas
	clr.w	amoebas_count
	clr.w	(a2)+
	move.l	a2,borderbricks
	clr.w	(a2)+
	move.l	a2,magic_bricks
	clr.w	(a2)+
	move.l	a2,times
	clr.w	(a2)+
	move.l	a2,dusts
	clr.w	(a2)+
	move.l	a2,lockers
	clr.w	(a2)+
	move.l	a2,keys
	clr.w	(a2)+
	move.l	a2,explodes
	clr.w	(a2)+
	move.l	a2,partial_dirt
	clr.w	(a2)+
	move.l	a2,bombs
	clr.w	(a2)+
	move.l	a2,apples
	clr.w	(a2)+
	move.l	a2,hard_rocks
	clr.w	(a2)+
	move.l	a2,gems
	clr.w	(a2)+
	move.l	a2,devils1
	clr.w	(a2)+
	move.l	a2,devils2
	clr.w	(a2)+
	move.l	a2,slimes
	clr.w	(a2)+
	move.w	#$0505,door
	move.w	#$0606,pos_hero
	bsr		new_map
	rts	
.present
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#loaded_version,LOAD_SAVE_BUF
	bsr	load
	cmp	#-1,loaded_version
	bmi	.new_version
	move.b	#64-12,level_limit
	move.b	#256-20,level_limit+1
	move.w	loaded_version,door
	bra	.old_version
.new_version
	move.w loaded_version,d0
	cmp	current_version,d0
	bgt	.notgood
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#level_limit,LOAD_SAVE_BUF
	bsr	load
	move.l	#1,LOAD_SAVE_LENGTH
	move.l	#picture_name+1,LOAD_SAVE_BUF
	bsr	load
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#door,LOAD_SAVE_BUF
	bsr	load
	cmp	#$8002,loaded_version
	blt	.continue_load
	move.l	#1,LOAD_SAVE_LENGTH
	move.l	#diamonds_sup_count,LOAD_SAVE_BUF
	bsr	load
.old_version
.continue_load
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	#pos_hero,LOAD_SAVE_BUF
	bsr	load		

	lea	objects,a2
	move.l	a2,null_type
	moveq	#0,d6
	bsr	loadobjects

	move.l	a2,bricks
	moveq	#0,d6
	bsr	loadobjects

	move.l	a2,rocks
	moveq	#1,d6
	bsr	loadobjects
***reseved 256 rocks
***To check in different levels
	add.l	#256*4,a2

	lea	(a3,d7),a3
	
	move.l	a2,diamonds
	move.l	a2,a1
	moveq	#1,d6
	bsr	loadobjects
***reseved 256 diamants
***To check in different levels
	add.l	#256*4,a2
	
	move.w	(a1),max_diamonds
	moveq #0,d6
	move.b diamonds_sup_count,d6
	add.w	d6,max_diamonds

	move.l	a2,fireflies
	moveq	#1,d6
	bsr	loadobjects

	move.l	a2,butterflies
	moveq	#1,d6
	bsr	loadobjects

	move.l	a2,amoebas
	move.l	a2,a1
	moveq	#0,d6
	bsr		loadobjects
	move.w	(a1),amoebas_count
	move.l	a2,borderbricks
	cmp		#$8003,loaded_version
	blt		.no_border_bricks
	moveq	#0,d6
	bsr		loadobjects
	bra		.border_bricks
.no_border_bricks
	clr.w	(a2)+	
.border_bricks
	move.l	a2,magic_bricks
	cmp		#$8004,loaded_version
	blt		.no_magic_bricks
	moveq	#0,d6
	bsr		loadobjects
	bra		.magic_bricks
.no_magic_bricks
	clr.w	(a2)+	
.magic_bricks
	cmp		#$8006,loaded_version
	blt		.no_times
	move.l	a2,times
	moveq	#0,d6
	bsr		loadobjects
	move.l	a2,dusts
	moveq	#0,d6
	bsr		loadobjects
	bra		.times
.no_times
	move.l	a2,times
	clr.w	(a2)+
	move.l	a2,dusts
	clr.w	(a2)+	
.times
	cmp		#$8007,loaded_version
	blt		.no_devils
	moveq	#1,d6
	move.l	a2,devils1
	bsr		loadobjects
	move.l	a2,devils2
	bsr		loadobjects
	bra		.devils
.no_devils
	move.l	a2,devils1
	clr.w	(a2)+
	move.l	a2,devils2
	clr.w	(a2)+	
.devils
	cmp		#$8008,loaded_version
	blt		.no_slimes
	move.l	a2,a1
	move.l	a2,slimes
	moveq	#0,d6
	bsr		loadobjects
	bra		.slimes
.no_slimes
	move.l	a2,slimes
	clr.w	(a2)+
.slimes	
	cmp		#$8005,loaded_version
	blt		.no_lockers_keys
	move.l	a2,lockers
	bsr		load_objects_and_anim
	move.l	a2,keys
	bsr		load_objects_and_anim
	bra		.lockers_keys
.no_lockers_keys
	move.l	a2,lockers
	clr.w	(a2)+
	move.l	a2,keys
	clr.w	(a2)+	
.lockers_keys
	cmp		#$8006,loaded_version
	blt		.no_bombs
	move.l	a2,bombs
	bsr		load_objects_and_anim
	move.l	a2,apples
	bsr		load_objects_and_anim
	move.l	a2,hard_rocks
	bsr		load_objects_and_anim
	move.l	a2,gems
	bsr		load_objects_and_anim
	bra		.bombs
.no_bombs
	move.l	a2,bombs
	clr.w	(a2)+
	move.l	a2,apples
	clr.w	(a2)+	
	move.l	a2,hard_rocks
	clr.w	(a2)+	
	move.l	a2,gems
	clr.w	(a2)+	
.bombs
	bsr	close
	move.l	a2,explodes
	move.w	#0,(a2)+
	lea		256(a2),a2
	move.l	a2,partial_dirt
	clr.w	(a2)+
	lea		256(a2),a2

	IFEQ	MASTER
	tst		use_memory_disk
	bne		.endload
	ENDC
	bsr		load_bnk
.endload
	rts

*IN:a2:buf
*	d6:with/without flags
*OUT:a2,d7
loadobjects:
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	a2,LOAD_SAVE_BUF
	bsr	load		
	move.w	(a2)+,d7
	add.w	d7,d7
	cmp	#$8003,loaded_version
	bge	.new_version
	tst	d6
	beq	.new_version
	add	d7,d7
.new_version
	moveq	#0,LOAD_SAVE_LENGTH
	move.w	d7,LOAD_SAVE_LENGTH
	move.l	a2,LOAD_SAVE_BUF
	bsr	load		
	
	cmp	#$8003,loaded_version
	blt	.old_version
	tst	d6
	beq	.old_version
	move.l	a2,a0
	lea	(a2,d7),a2
	add	d7,d7
	lea	(a0,d7),a0
	move d7,d0
	lsr #2,d0
	subq	#1,d0
	bmi	.old_version
.loop_copy
	clr.w	-(a0)
	move.w	-(a2),-(a0)
	dbra	d0,.loop_copy
.old_version
	lea	(a2,d7),a2
	rts

load_objects_and_anim:
	move.l	#2,LOAD_SAVE_LENGTH
	move.l	a2,LOAD_SAVE_BUF
	bsr	load		
	moveq	#0,LOAD_SAVE_LENGTH
	move.w	(a2)+,LOAD_SAVE_LENGTH
	add.w	LOAD_SAVE_LENGTH,LOAD_SAVE_LENGTH
	add.w	LOAD_SAVE_LENGTH,LOAD_SAVE_LENGTH
	move	LOAD_SAVE_LENGTH,d7
	move.l	a2,LOAD_SAVE_BUF
	bsr	load		
	lea	(a2,d7),a2
	rts

*****************************************
*MAKE LEVEL	
*****************************************
makelevel:
	clr.l	keys_inventory
	lea	map,a1
	lea	map_anim,a2
	lea	door,a0
	moveq	#0,d1
	move.w	(a0)+,d1
	move.b	#TYPE_DOOR,(a1,d1)
	move.l	null_type,a0	
	moveq	#TYPE_NULL,d7
	bsr	makeobject
	move.l	bricks,a0
	moveq	#TYPE_BRICK,d7	
	bsr	makeobject
	move.l	rocks,a0
	moveq	#TYPE_ROCK,d7
	bsr	makeobject_with_flags
	move.l	diamonds,a0
	moveq	#TYPE_DIAMOND,d7
	bsr	makeobject_with_flags
	move.l	fireflies,a0
	moveq	#TYPE_FIREFLY,d7
	bsr	makeobject_with_flags
	move.l	butterflies,a0
	moveq	#TYPE_BUTTERFLY,d7
	bsr	makeobject_with_flags
	move.l	amoebas,a0
	moveq	#TYPE_AMOEBA,d7
	bsr	makeobject
	move.l	borderbricks,a0
	moveq	#TYPE_BORDERBRICK,d7
	bsr	makeobject
	move.l	magic_bricks,a0
	moveq	#TYPE_MAGIC_BRICK,d7
	bsr	makeobject
	move.l	times,a0
	moveq	#TYPE_TIME,d7
	bsr	makeobject
	move.l	dusts,a0
	moveq	#TYPE_DUST,d7
	bsr	makeobject
	move.l	devils1,a0
	moveq	#TYPE_DEVIL1,d7
	bsr	makeobject_with_flags
	move.l	devils2,a0
	moveq	#TYPE_DEVIL2,d7
	bsr	makeobject_with_flags
	move.l	slimes,a0
	moveq	#TYPE_SLIME,d7
	bsr	makeobject
	move.l	lockers,a0
	moveq	#TYPE_LOCKER,d7
	bsr	make_object_and_anim
	move.l	keys,a0
	moveq	#TYPE_KEY,d7
	bsr	make_object_and_anim
	move.l	bombs,a0
	moveq	#TYPE_BOMB,d7
	bsr	make_object_and_anim
	move.l	apples,a0
	moveq	#TYPE_APPLE,d7
	bsr	make_object_and_anim
	move.l	hard_rocks,a0
	moveq	#TYPE_HARD_ROCK,d7
	bsr	make_object_and_anim
	move.l	gems,a0
	moveq	#TYPE_GEM,d7
	bsr	make_object_and_anim
	move.l	#magic_list,current_magic
	bsr	random_amoeba_time

	rts
*IN:a0:objects, d7:type
*OUT:a0
makeobject:
	move.w	(a0)+,d0
	subq	#1,d0
	bmi	.level_over
	moveq	#0,d1
.loopv	
	move.w	(a0)+,d1
	move.b	d7,(a1,d1)
	clr.b	(a2,d1)
	dbra	d0,.loopv
.level_over
	rts

makeobject_with_flags:
	move.w	(a0)+,d0
	subq	#1,d0
	bmi	.level_over
	moveq	#0,d1
.loopv	
	move.w	(a0)+,d1
	addq	#2,a0
	move.b	d7,(a1,d1)	
	clr.b	(a2,d1)
	dbra	d0,.loopv
.level_over
	rts

make_object_and_anim:
	move.w	(a0)+,d0
	subq	#1,d0
	bmi	.level_over
	moveq	#0,d1
.loopv	
	move.w	(a0)+,d1
	move.b	d7,(a1,d1)
	move.b	(a0)+,(a2,d1)
	addq.l	#1,a0
	dbra	d0,.loopv
.level_over
	rts


*****************************************
*CLEAR	MAP
*****************************************	
new_map:
	lea	map,a0
	lea	map_anim,a1
	move.w	#MAX_MAP_X-1,d0
.loop1
	move.b	#TYPE_BORDERBRICK,(a0)+
	move.b	#0,(a1)+
	dbra	d0,.loop1
	
	move.w	#MAX_MAP_Y-2-1,d0
.loop2
	move.b	#TYPE_BORDERBRICK,(a0)+
	move.b	#0,(a1)+

	move.w	#MAX_MAP_X-2-1,d1
.loop2b	
	move.b	#1,(a0)+	
	bsr		random
	move.b	d6,(a1)+
	dbra	d1,.loop2b
	move.b	#TYPE_BORDERBRICK,(a0)+
	move.b	#0,(a1)+
	dbra	d0,.loop2
	
	move.w	#MAX_MAP_X-1,d0
.loop3	
	move.b	#TYPE_BORDERBRICK,(a0)+
	move.b	#0,(a1)+
	dbra	d0,.loop3

	rts

clear_map_macro	macro
	bsr		random
	moveq	#1,d4
	moveq	#8-1,d0
.\@loop1
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#3,d6
	rol		#3,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#7,d6
	rol		#1,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#3,d6
	rol		#3,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#5,d6
	rol		#2,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#3,d6
	rol		#3,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#1,d6
	rol		#3,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#3,d6
	rol		#3,d6
	move.b	d4,(a0)+
	move.b	d6,(a1)+
	addq	#5,d6
	rol		#2,d6
	lea		MAX_MAP_X-8(a0),a0
	lea		MAX_MAP_X-8(a1),a1
	dbra	d0,.\@loop1
	ENDM
clear_map:
	lea	map,a2
	lea	map_anim,a3
	move	#8-1,d1
.loop1
V	SET	0
	REPT	32
	lea	V(a2),a0
	lea	V(a3),a1
	clear_map_macro
V	SET	V+8
	ENDR
	lea		8*MAX_MAP_X(a2),a2
	lea		8*MAX_MAP_X(a3),a3
	dbra	d1,.loop1
	rts

