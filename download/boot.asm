_PLLC_PLLCTL_ADDR  	.equ    0x029A0100
_PLLC_PLLM_ADDR    	.equ    0x029A0110
_PLLC_PREDIV_ADDR	.equ	0x029A0114
_PLLC_PLLCMD_ADDR	.equ	0x029A0138
_PLLC_PLLSTAT_ADDR	.equ	0x029A013C

_LOOP_CNT1			.equ	0x000007D0
_LOOP_CNT2			.equ	0x0000001E
_LOOP_CNT3			.equ	0x00000190
_PLLC_PLLCTL_PLLRST	.equ	0x00000008
_PLLC_PLLM_KEY		.equ	0x00000013
_PLLC_PREDIV_KEY	.equ	0x00008000
_PLLC_PLLCMD_GO		.equ	0x00000001
_PLLC_PLLCTL_RSTRLS	.equ	0x00000000
_PLLC_PLLCTL_PLLEN	.equ	0x00000001

_PERCFG1_ADDR       .equ    0x02AC002C
_DDR2_SDCFG_ADDR    .equ    0x78000008
_DDR2_SDRFC_ADDR    .equ    0x7800000C
_DDR2_SDTIM1_ADDR   .equ    0x78000010
_DDR2_SDTIM2_ADDR   .equ    0x78000014
_DDR2_DMCCTL_ADDR   .equ    0x780000E4

_PERCFG1_KEY        .equ    0x00000003
_DDR2_SDCFG_KEY1    .equ    0x00008A32
_DDR2_SDTIM1_KEY    .equ    0xA0DB5391
_DDR2_SDTIM2_KEY    .equ    0x0155C722
_DDR2_SDRFC_KEY     .equ    0x0000079E
_DDR2_SDCFG_KEY2    .equ    0x00000A32
_DDR2_DMCCTL_KEY    .equ    0x00000006

       .list
       .title  "Flash bootup utility for 6455 dsk"
       .option D,T
       .length 102
       .width  140

COPY_TABLE    .equ    0xb0000400
       .sect ".boot_load"
       .global _boot
_boot:
;************************************************************************
;* Debug Loop -  Comment out B for Normal Operation
;************************************************************************
            zero B1
_myloop:  ; [!B1] B _myloop
            nop  5
_myloopend: nop
;****************************************************************************
;* Pllc Config
;****************************************************************************
		mvkl _LOOP_CNT1, a0
    	mvkh _LOOP_CNT1, a0
LOOP1: 	sub a0,1,a0
 [a0]	bnop LOOP1, 5

        mvkl _PLLC_PLLCTL_ADDR, a0
    ||  mvkl _PLLC_PLLCTL_PLLRST, b0
        mvkh _PLLC_PLLCTL_ADDR, a0
    ||  mvkh _PLLC_PLLCTL_PLLRST, b0
        stw b0, *a0

        mvkl _PLLC_PREDIV_ADDR, a0
    ||  mvkl _PLLC_PREDIV_KEY, b0
        mvkh _PLLC_PREDIV_ADDR, a0
    ||  mvkh _PLLC_PREDIV_KEY, b0
        stw b0, *a0

        mvkl _PLLC_PLLM_ADDR, a0
    ||  mvkl _PLLC_PLLM_KEY, b0
        mvkh _PLLC_PLLM_ADDR, a0
    ||  mvkh _PLLC_PLLM_KEY, b0
        stw b0, *a0

        mvkl _PLLC_PLLCMD_ADDR, a0
    ||  mvkl _PLLC_PLLCMD_GO, b0
        mvkh _PLLC_PLLCMD_ADDR, a0
    ||  mvkh _PLLC_PLLCMD_GO, b0
        stw b0, *a0

        mvkl _PLLC_PLLSTAT_ADDR, a0
        mvkh _PLLC_PLLSTAT_ADDR, a0
WAIT:   ldw  *a0, b0
        nop 4
        and 1, b0, b0
 [b0]   bnop WAIT, 5

        mvkl _LOOP_CNT2, a0
    	mvkh _LOOP_CNT2, a0
LOOP2: 	sub a0,1,a0
 [a0]	bnop LOOP2, 5

        mvkl _PLLC_PLLCTL_ADDR, a0
    ||  mvkl _PLLC_PLLCTL_RSTRLS, b0
        mvkh _PLLC_PLLCTL_ADDR, a0
    ||  mvkh _PLLC_PLLCTL_RSTRLS, b0
        stw b0, *a0

        mvkl _LOOP_CNT3, a0
    	mvkh _LOOP_CNT3, a0
LOOP3: 	sub a0,1,a0
 [a0]	bnop LOOP3, 5

        mvkl _PLLC_PLLCTL_ADDR, a0
    ||  mvkl _PLLC_PLLCTL_PLLEN, b0
        mvkh _PLLC_PLLCTL_ADDR, a0
    ||  mvkh _PLLC_PLLCTL_PLLEN, b0
        stw b0, *a0

;****************************************************************************
;* DDR2 Config
;****************************************************************************
	    mvkl _PERCFG1_ADDR, a0
	||  mvkl _PERCFG1_KEY, b0
	    mvkh _PERCFG1_ADDR, a0
	||  mvkh _PERCFG1_KEY, b0
	    stw b0, *a0

	    mvkl _DDR2_SDCFG_ADDR, a0
	||  mvkl _DDR2_SDCFG_KEY1, b0
	    mvkh _DDR2_SDCFG_ADDR, a0
	||  mvkh _DDR2_SDCFG_KEY1, b0
	    stw b0, *a0

	    mvkl _DDR2_SDTIM1_ADDR, a0
	||  mvkl _DDR2_SDTIM1_KEY, b0
	    mvkh _DDR2_SDTIM1_ADDR, a0
	||  mvkh _DDR2_SDTIM1_KEY, b0
	    stw b0, *a0

	    mvkl _DDR2_SDTIM2_ADDR, a0
	||  mvkl _DDR2_SDTIM2_KEY, b0
	    mvkh _DDR2_SDTIM2_ADDR, a0
	||  mvkh _DDR2_SDTIM2_KEY, b0
	    stw b0, *a0

	    mvkl _DDR2_SDRFC_ADDR, a0
	||  mvkl _DDR2_SDRFC_KEY, b0
	    mvkh _DDR2_SDRFC_ADDR, a0
	||  mvkh _DDR2_SDRFC_KEY, b0
	    stw b0, *a0

	    mvkl _DDR2_SDCFG_ADDR, a0
	||  mvkl _DDR2_SDCFG_KEY2, b0
	    mvkh _DDR2_SDCFG_ADDR, a0
	||  mvkh _DDR2_SDCFG_KEY2, b0
	    stw b0, *a0

	    mvkl _DDR2_DMCCTL_ADDR, a0
	||  mvkl _DDR2_DMCCTL_KEY, b0
	    mvkh _DDR2_DMCCTL_ADDR, a0
	||  mvkh _DDR2_DMCCTL_KEY, b0
	    stw b0, *a0

;****************************************************************************
;* EMIF Config just as default
;****************************************************************************


;****************************************************************************
;* Copy code sections
;****************************************************************************
       mvkl  COPY_TABLE, a3   ; load table pointer
       mvkh  COPY_TABLE, a3
       ldw   *a3++, b1        ; Load entry point

copy_section_top:
       ldw   *a3++, b0        ; byte count
       ldw   *a3++, a4        ; ram start address
       nop   3

 [!b0]  b copy_done            ; have we copied all sections?
       nop   5

copy_loop:
       ldb   *a3++,b5
       sub   b0,1,b0          ; decrement counter
 [ b0]  b     copy_loop        ; setup branch if not done
 [!b0]  b     copy_section_top
       zero  a1
 [!b0]  and   3,a3,a1
       stb   b5,*a4++
 [!b0]  and   -4,a3,a5         ; round address up to next multiple of 4
 [ a1]  add   4,a5,a3          ; round address up to next multiple of 4

;****************************************************************************
;* Jump to entry point
;****************************************************************************
copy_done:
       b    .S2 b1
       nop   5
