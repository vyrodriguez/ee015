*********************PROGRAMA EJEMPLO MICRO HC908JL8********************************
***********-------------------------------------------------------------------******
;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
VRST    EQU     $FFFE
VTMR    EQU     $FFF2
PUERTA  EQU     $0000       ;HABILITACION DE LOS DISPLAY Y FREC DE ENTRADA 
;--------------------------------------------
;|PA7|PA6|PA5|PA4|PA3|PA2|PA1|PA0|
;--------------------------------------------
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
;| - | - | 0 | 1 | 0 | 0 | 0 | 0 |
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
BIN		RMB		1
BCDH	RMB		1		   ;Parte alta del BCD
BCDL	RMB		1		   ;Parte baja del BCD
CENTENA	RMB		1		   
DECENA	RMB		1
UNIDAD	RMB		1
CUENTA  RMB     2
CONTEO  RMB     2
ANT     RMB     1           ; DEFINE EL ESTADO ANTERIOR 
DSEL    RMB     1           ;DISPLAY QUE COMIENZA PRENDIDO(PRENDETE UNO)
CARRY   RMB     1
TIEMPO  RMB     1
				 		  ;7 segmentos;abcdefgh  
TABLA   FCB     $FC		   ;Número 0 %11111100
		FCB		$60		   ;Número 1 %01100000
		FCB		$DA		   ;Número 2 %11011010
		FCB		$F2		   ;Número 3 %11110010
		FCB		$66		   ;Número 4 %01100110   ;FCB (FORM CONSTANT BYTE)
		FCB		$B6		   ;Número 5 %10110110
		FCB		$BE		   ;Número 6 %10111110
		FCB		$E0		   ;Número 7 %11100000
		FCB		$FE		   ;Número 8 %11111110
		FCB		$E6		   ;Número 9 %11110110

;-----------------PROCESO----------------
        ORG     ROM
inicio  RSP                 ;RESETEAR PUNTERO DE PILA
        BSET    0,CONF1     ;DESHABILITAR COP
        CLI                 ;HABILITA INTERRUPCIONES AL CPU(bit I=0 EN EL CCR)    
        BSR     INIPUERTO   ;SUBRUTINA INICIALIZAR PUERTO
        BSR     INITIMER    ;SUBRUTINA INICIALIZAR TIMER
        CLR     ANT         
        CLR     CONTEO
        CLR     CONTADOR
        CLR     BIN
        CLR     UNIDAD
        CLR     DECENA
        CLR     CENTENA
        CLR     BCDH
        CLR     BCDL
        CLR     TIEMPO
LAZO    CLC                 ;LIMPIA FLAG DE CARRY
        CLR     CARRY       ;LIMPIA VARIABLE DE CARRY 
        LDA     PUERTA      ;LEO PUERTO A
        AND     #$08        ;APLICO MASCARA PARA LEER LA FRECUENCIA
        STA     ANT         ;ESTADO ANTERIOR DE LA SEÑAL
        CMP     #$08        
        BNE     LAZO
        LDA     CARRY
        CMP     #$01
        BNE     SALTO1
        INC     CONTEO      ;INCREMENTA PARTE ALTA DE CONTEO 
        CLR     CONTEO+1    ;LIMPIA PARTE BAJA DE CONTEO
SALTO1  INC     CONTEO+1    ;iNCREMENTA PARTE BAJA DE CONTEO 
        CLR     CARRY       ;LIMPIA VARIABLE CARRY
        ROL     CARRY       ;EMPUJA FLAG DE CARRY A VARIABLE CARRY
SALTO2  LDA     PUERTA      ;CARGO ESTADO DE PUERTO A
        AND     #$08        ;APLICO MASCARA
        STA     ANT         ;GUARDO ESTADO ANTERIOR
        CMP     #$08        
        BNE     SALTO2
        BRA     LAZO

;--------------------------------------------
        ORG     inter
        EOR    #%10000000
        BSR     MULTIPLEX
        INC     TIEMPO
        CMP     #!200
        BNE     SALTO3
        CLR     TIEMPO
        LDA     CONTEO+1
        STA     CUENTA+1
        CLR     CONTEO+1
        LDA     CONTEO
        STA     CUENTA
        CLR     CONTEO
        BSR     BIN2BCD
        BSR     BCD27
SALTO3  RTI
;--------------------------------------------



;--------------------------------------------
INIPUERTO	LDA     #$10 	;
            STA     DDRA    ;
            LDA     #$FF
			STA     DDRB 
            LDA     #$00
            STA     PUERTA  ;INICIALIZAMOS EL PUERTO A EN CERO
            STA     PUERTB  ;INICIALIZAMOS EL PUERTO B EN CERO
			RTS	    			 ;
;--------------------------------------------
INITIMER    LDHX    #$1800  ;MODULO DEL CONTADOR
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


;----------------Reset------------------
        ORG     VRST
        FDB     inicio
;--------INTERRUPCION DEL TIMER---------
        ORG     VTMR
        FDB     inter