MASTER equ 1
PLAY_MUSIC equ 1
	IFNE PLAY_MUSIC
	section	data
music:	incbin	"rocheltd.snd"
	section text
	ENDC
	IFEQ	MASTER
	OPT	O+,D+,W-,S-
	ENDC
	IFNE	MASTER
	OPT	O+,D-,W-,S-
	ENDC
	include "BOULDER.S"