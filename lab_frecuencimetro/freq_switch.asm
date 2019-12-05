
;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
VRST    EQU     $FFFE
VTMR    EQU     $FFF2
PUERTA  EQU     $0000       ;HABILITACION DE LOS DISPLAY Y FREC DE ENTRADA 
;--------------------------------------------
;|PA7|PA6|PA5|PA4|PA3|PA2|PA1|PA0|
;--------------------------------------------
;|0|0|0|1|0|1|1|1|
;PA0 HABILITACION DE UNIDAD
;PA1 HABILITACION DE DECENA
;PA2 HABILIRACION DE CENTENA
;PA3 FRECUENCIA DE ENTRADA
;PA4 LED
;PA5 SWITCH X1(PA5==1) X10 (PA5==0)
;PA6 NADA
;PA7 NO SE UTILIZA
DDRA    EQU     $0004
;--------------------------------------------
;|PA7|PA6|PA5|PA4|PA3|PA2|PA1|PA0|
;--------------------------------------------
;| - | - | 0 | 1 | 0 | 1 | 1 | 1 |
;--------------------------------------------
PUERTB  EQU     $0001
;--------------------------------------------
;|PB7|PB6|PB5|PB4|PB3|PB2|PB1|PB0|
;--------------------------------------------
;PB0 DECIMAL POINT
;PB1 g
;PB2 f
;PB3 e
;PB4 d
;PB5 c
;PB6 b
;PB7 a
;--------------------------------------------
DDRB    EQU     $0005
;--------------------------------------------
;|PB7|PB6|PB5|PB4|PB3|PB2|PB1|PB0|
;--------------------------------------------
;| 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
;--------------------------------------------
CONF1   EQU     $001F       ;REGISTRO DEL COP
TSC     EQU     $0020       ;REGISTRO DE ESTADO DEL TIMER
TMOD    EQU     $0023       ;MODULO ALTO DEL CONTADOR


;----------------VARIABLES---------------
        ORG     RAM
CENTENA	RMB	1		   
DECENA	RMB	1
UNIDAD	RMB	1
CONTEO  RMB     2
ANT     RMB     1           ; DEFINE EL ESTADO ANTERIOR 
DSEL    RMB     1           ;DISPLAY QUE COMIENZA PRENDIDO(PRENDETE UNO)
CARRY   RMB     1
TIEMPO  RMB     1
VAL         DS 1   ;Se define la variable de 24bits (3bytes)
VAL1	    DS 1
VAL2	    DS 1
RESULT      DS 1   ;Variables del resultado en BCD (Cada byte contiene 2 BCD)
RESULT1	    DS 1
RESULT2     DS 1
RESULT3	    DS 1


;-----------------PROCESO----------------
        ORG     ROM
TABLA   FCB     $FC		   ;N�mero 0 %11111100
        FCB		$60		   ;N�mero 1 %01100000
        FCB		$DA		   ;N�mero 2 %11011010
        FCB		$F2		   ;N�mero 3 %11110010
        FCB		$66		   ;N�mero 4 %01100110   ;FCB (FORM CONSTANT BYTE)
        FCB		$B6		   ;N�mero 5 %10110110
        FCB		$BE		   ;N�mero 6 %10111110
        FCB		$E0		   ;N�mero 7 %11100000
        FCB		$FE		   ;N�mero 8 %11111110
        FCB		$E6		   ;N�mero 9 %11110110
inicio  RSP                 ;RESETEAR PUNTERO DE PILA
        BSET    0,CONF1     ;DESHABILITAR COP
        CLI                 ;HABILITA INTERRUPCIONES AL CPU(bit I=0 EN EL CCR)    
        BSR     INIP   ;SUBRUTINA INICIALIZAR PUERTO
        BSR     INIT    ;SUBRUTINA INICIALIZAR TIMER
        CLR     CENTENA
        CLR     DECENA
        CLR     UNIDAD
        CLR     CONTEO
        CLR     CONTEO+1
        CLR     ANT         
        CLR     DSEL
        INC     DSEL
        CLR     TIEMPO
        CLRA
LAZO    LDA     PUERTA      ;LEO PUERTO A
        AND     #$08        ;APLICO MASCARA PARA LEER LA FRECUENCIA
        STA     ANT         ;ESTADO ANTERIOR DE LA SEÑAL
        CMP     #$08        
        BNE     LAZO
        LDA	CONTEO+1
        ADD	#$01
        STA	CONTEO+1
        BCC	SALTO2
        INC	CONTEO
SALTO2  LDA     PUERTA      ;CARGO ESTADO DE PUERTO A
        AND     #$08        ;APLICO MASCARA
        STA     ANT         ;GUARDO ESTADO ANTERIOR
        CMP     #$08        
        BNE     LAZO
        BRA     SALTO2


;--------------------------------------------
INIP    LDA     #$17 	;
        STA     DDRA    ;
        LDA     #$FF
        STA     DDRB 
        LDA     #$00
        STA     PUERTA  ;INICIALIZAMOS EL PUERTO A EN CERO
        STA     PUERTB  ;INICIALIZAMOS EL PUERTO B EN CERO
        RTS	    			 ;
;--------------------------------------------
INIT    LDHX    #$1800  ;MODULO DEL CONTADOR
        STHX    TMOD
        LDA     #%01000001
;--------------------------------------------
;|TOF|TOIE|TSTOP|TRST|----|PS2|PS1|PS0|
;--------------------------------------------
;TOF =1 FLAG DE INTERRUPCIÓN DEL TIMER.
;TOIE =1 HABILITA INTERUPCIONES POR OVERFLOW DEL TIMER 
;TSTOP=0 HABILITA EL CONTADOR FREE RUNNING
;TRST=1 RESET DEL MODULO 
;PS[2:0] CONFIGURA EL PRESCALER 
;--------------------------------------------
        STA     TSC
        RTS

KBCD27  LDA     RESULT+2
        AND	#$0F
        TAX
        CLRH
		LDA	TABLA,X
        STA	DECENA
        LDA	RESULT+2
        NSA
        AND	#$0F
        TAX
        LDA	TABLA,X
        STA	CENTENA
		INC CENTENA
        LDA	RESULT+3
        NSA
        AND	#$0F
        TAX
        LDA	TABLA,X
        STA	UNIDAD
        RTS

BCD27   LDA     RESULT+2
        AND	#$0F
        TAX
        CLRH
		LDA	TABLA,X
        STA	CENTENA
        LDA	RESULT+3
        AND	#$0F
        TAX
        LDA	TABLA,X
        STA	UNIDAD
        LDA	RESULT+3
        NSA
        AND	#$0F
        TAX
        LDA	TABLA,X
        STA	DECENA
        RTS
;--------------------------------------------
inter   LDA     TSC
        EOR    #%10000000
        STA     TSC
        BSR     MPLEX
        INC     TIEMPO
		LDA		TIEMPO
        CMP     #!200
        BNE     SALTO3
        CLR     TIEMPO
        BSR     BIN2BCD
        LDA     PUERTA
        AND     #$20    ; LEE SWITCH
        CMP     #$20
        BNE     SALTO8
        BSR     KBCD27
        LDA     PUERTA
        EOR     #$10
        STA     PUERTA
        RTI
SALTO8  BSR     BCD27
SALTO3  RTI
;--------------------------------------------

MPLEX   LDA     PUERTA
        AND     #$F8
        STA     PUERTA
        BRCLR   3,DSEL,SALTO4
        CLR     DSEL
        INC     DSEL
        RTS
SALTO4  BRCLR   2,DSEL,SALTO5
        LDA     CENTENA
        BSR     SUB21
SALTO5  BRCLR   1,DSEL,SALTO6
        LDA     DECENA
        BSR     SUB21
SALTO6  BRCLR   0,DSEL,SALTO7
        LDA     UNIDAD
        BSR     SUB21
SALTO7  LDA     DSEL
        LSLA
        STA     DSEL
        RTS

;------------------------------------------------
;SUBRUTINA BCD_CONV
;Convierte un dato binario de 24 bits en BCD


BIN2BCD    LDA		#$00   ;carga valor binario A:H:X = $FFFFFF = 16 77 72 15
	   LDHX		CONTEO
           CLR          CONTEO
           CLR          CONTEO+1
	   STA		VAL            ; inicializa variable VAL:VAL1:VAL2
	   STHX		VAL+1
	   BSR    	BCD_CONV    ;ejecuta subrutina de conversion
           RTS



BCD_CONV:LDX    #!24            ; Bit count
         CLR    RESULT+3
         CLR    RESULT+2
         CLR    RESULT+1
         CLR    RESULT
BC1:     LDA    RESULT+3
         JSR    BCD_ADJ        ; Adjust for BCD conversion
         STA    RESULT+3
         LDA    RESULT+2
         JSR    BCD_ADJ        ; Adjust for BCD conversion
         STA    RESULT+2
         LDA    RESULT+1
         JSR    BCD_ADJ        ; Adjust for BCD conversion
         STA    RESULT+1
         LDA    RESULT
         JSR    BCD_ADJ        ; Adjust for BCD conversion
         STA    RESULT
         LSL    VAL+2
         ROL    VAL+1
         ROL    VAL
         ROL    RESULT+3
         ROL    RESULT+2
         ROL    RESULT+1
         ROL    RESULT
         DBNZX  BC1            ; Loop for next bit
         RTS



BCD_ADJ: TSTA
         BEQ    BA1            ; Exit if zero
         PSHA

         ; Process lower nybble
         AND    #$0F
         CMP    #5
         BLO    *+4            ; Skip next if <5
         ADD    #3
         PSHA

         ; Process upper nybble
         LDA    2,SP           ; Initial byte value
         NSA
         AND    #$0F
         CMP    #5
         BLO    *+4            ; Skip next if <5
         ADD    #3
         NSA
         ORA    1,SP           ; Combine nybbles
         AIS    #2             ; Adjust stack pointer
BA1:     RTS
;----------------------------------------
SUB21   STA     PUERTB
        LDA     PUERTA
        EOR     DSEL
        STA     PUERTA
        RTS
		


;----------------Reset------------------------
        ORG     VRST
        FDB     inicio
;--------INTERRUPCION DEL TIMER--------------
        ORG     VTMR
        FDB     inter
