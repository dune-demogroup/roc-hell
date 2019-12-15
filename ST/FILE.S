*********************************************
*********************************************
*********************************************
*********************************************
*********************************************
*********************************************
*********************************************
*********************************************
 
FILENAME_LOAD 	equr d1
FILENAME_SAVE 	equr d1
LOAD_SAVE_LENGTH	equr d0
LOAD_SAVE_BUF	equr d1

	section	text
open
	IFEQ	MASTER
	moveq	#0,d0
	move.l	#memory_disk,memory_disk_ptr
	tst		use_memory_disk
	bne		.mem_disk
	ENDC

	move.w	#$2,-(sp)
	move.l	FILENAME_LOAD,-(sp)
	move.w	#$3d,-(sp)
	trap	#1
	addq.l	#8,sp
	move.l	handlebuf,a0
	move.w	d0,(a0)
.mem_disk
	tst	d0
	rts
	
	section text
load	
	IFEQ	MASTER
	tst		use_memory_disk
	bne		.mem_disk
	ENDC
	move.l	LOAD_SAVE_BUF,-(sp)
	move.l	LOAD_SAVE_LENGTH,-(sp)
	move.l	handlebuf,a0
	move.w	(a0),-(sp)
	move.w	#$3f,-(sp)
	trap	#1
	add.l	#12,sp
	tst	d0
	rts
	IFEQ	MASTER
.mem_disk
	tst		d0
	bne		.ok1
	rts
.ok1
	movem.l	a0/a1,-(sp)
	move.l	memory_disk_ptr,a0
	lea		(a0,d0),a1
	cmp.l	#memory_disk+128000,a1
	blt		.ok2
	movem.l	(sp)+,a0/a1
	moveq	#-1,d0
	rts
.ok2
	move.l	d1,a1
	move	d0,d1
	subq	#1,d0
.loop
	move.b	(a0)+,(a1)+
	dbra	d0,.loop
	move.l	a0,memory_disk_ptr
	movem.l	(sp)+,a0/a1
	move	d1,d0
	rts
	ENDC

create:
	IFEQ	MASTER
	moveq	#0,d0
	move.l	#memory_disk,memory_disk_ptr
	tst		use_memory_disk
	bne		.mem_disk
	ENDC
	move.w	#$0,-(sp)
	move.l	FILENAME_SAVE,-(sp)
	move.w	#$3c,-(sp)
	trap	#1
	addq.l	#8,sp
	move.l	handlebuf,a0
	move.w	d0,(a0)
.mem_disk
	tst		d0
	rts

save	
	IFEQ	MASTER
	tst		use_memory_disk
	bne		.mem_disk
	ENDC
	move.l	LOAD_SAVE_BUF,-(sp)
	move.l	LOAD_SAVE_LENGTH,-(sp)
	move.l	handlebuf,a0
	move.w	(a0),-(sp)
	move.w	#$40,-(sp)
	trap	#1
	add.l	#12,sp
	tst		d0
	rts
	IFEQ	MASTER
.mem_disk
	tst		d0
	bne		.ok1
	rts
.ok1
	movem.l	a0/a1,-(sp)
	move.l	memory_disk_ptr,a0
	lea		(a0,d0),a1
	cmp.l	#memory_disk+128000,a1
	blt		.ok2
	movem.l	(sp)+,a0/a1
	moveq	#-1,d0
	rts
.ok2	
	move.l	d1,a1
	move	d0,d1
	subq	#1,d0
.loop
	move.b	(a1)+,(a0)+
	dbra	d0,.loop
	move.l	a0,memory_disk_ptr
	movem.l	(sp)+,a0/a1
	move	d1,d0
	rts
	ENDC
	
seek:	
	IFEQ	MASTER
	tst		use_memory_disk
	bne		.mem_disk
	ENDC
	move.w	#1,-(sp)
	move.l	handlebuf,a0
	move.w	(a0),-(sp)
	move.l	espace,-(sp)
	move.w	#66,-(sp)
	trap	#1
	add.l	#10,sp
	tst	d0
	rts
	IFEQ	MASTER
.mem_disk
	tst		d0
	bne		.ok1
	rts
.ok1
	movem.l	a0,-(sp)
	move.l	memory_disk_ptr,a0
	lea		(a0,d0),a0
	cmp.l	#memory_disk+128000,a0
	blt		.ok2
	movem.l	(sp)+,a0
	moveq	#-1,d0
	rts
.ok2
	movem.l	(sp)+,a0
	tst		d0
	rts
	ENDC

close:
	IFEQ	MASTER
	moveq	#-1,d0
	tst		use_memory_disk
	bne		.mem_disk
	ENDC
	
	move.l	handlebuf,a0
	move.w	(a0),-(sp)
	move.w	#$3e,-(sp)
	trap	#1
	addq.l	#4,sp
	tst	d0
.mem_disk
	rts

error:
	clr.w	-(sp)
	trap	#1
	rts
	

handlebuf
	dc.l	handle
handle	dc.w	0
espace	dc.l	0
	IFEQ	MASTER
use_memory_disk
	dc.w	0
memory_disk_ptr
	dc.l	0
	ENDC
	IFEQ	MASTER
	section	bss
memory_disk
	ds.b	128000
	ENDC

	section	text