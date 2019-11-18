;----------------ETIQUETAS---------------
RAM       	 EQU     $0080
ROM          EQU     $EC00
INTERRUPCION EQU     $FFF2
Reset        EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
BIN		RMB		1
BCDH	RMB		1		   ;Parte alta del BCD
BCDL	RMB		1		   ;Parte baja del BCD
CENTENA	RMB		1		   
DECENA	RMB		1
UNIDAD	RMB		1

				 		  7 segmentos;abcdefgh  
TABLA   FCB     $FC		   ;Número 0 %11111100
		FCB		$60		   ;Número 1 %01100000
		FCB		$DA		   ;Número 2 %11011010
		FCB		$F2		   ;Número 3 %11110010
		FCB		$66		   ;Número 4 %01100110
		FCB		$B6		   ;Número 5 %10110110
		FCB		$BE		   ;Número 6 %10111110
		FCB		$E0		   ;Número 7 %11100000
		FCB		$FE		   ;Número 8 %11111110
		FCB		$E6		   ;Número 9 %11110110
;-----------------PROCESO----------------		
        ORG     ROM
INICIO	LDX		#$0B
		CLR		BCDL
		CLR		BCDH
SALTO0	LSL		BIN
		ROL		BCDL
		ROL		BCDH
		LDA		BCDL
		AND		#$0F
		CMP		#$05
		BMI		SALTO1
		LDA		BCDL
		ADD		#$03
		STA		BCDL
SALTO1	LDA		BCDL
		AND		#$F0
		CMP		#$50
		BMI		SALTO2
		LDA		BCDL
		ADD		#$30
		STA		BCDL
SALTO2	LDA		BCDL
		DECX
		CPX		#$00
		BNE		SALTO0
		LSL		BIN
		ROL		BCDL
		ROL		BCDH  ;TERMINA BIN2BCD
		
		LDA		BCDH
		AND		#$0F
		TAX
		LDA		Tabla,X
		STA		CENTENA
		LDA		BCDL
		AND		#$0F
		TAX
		LDA		Tabla,X
		STA		UNIDAD
		LDA		BCDL
		NSA
		AND		#$0F
		TAX
		LDA		Tabla,X
		STA		DECENA
		BRA		INICIO

;-------------Interrupción--------------
		ORG		INTERRUPCION
		
		
;----------------Reset------------------
        ORG     Reset
        FDB     ROM