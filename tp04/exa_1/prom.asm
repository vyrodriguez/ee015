;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
BYTES   EQU     !64
;----------------VARIABLES---------------
        ORG     RAM
TABLA   RMB     !64     ;DEFINO LA TABLA Y RESERVO 64 BYTES
SUMAT   RMB     2       ;
PROM    RMB     1
PROMF   RMB     1
CUENTA  RMB     1;
;-----------------PROCESO----------------
        ORG     ROM
EJ19    RSP
PPAL    BSR     SUMA
        BSR     DIVI
        BSR     BIN2BCD
        BRA     PPAL

;--------------SUB. SUMA----------------
SUMA    CLRH                ;H=0
        CLRX                ;X=0
        STHX    SUMAT       ;INICIALIZA SUMAT =$0000
CICLO   LDA     TABLA,X    ;[TABLA+X:X]->A
        ADD     SUMAT+1     ;A+[SUMAT+1]->A
        STA     SUMAT+1     ;A->[SUMAT+1] GUARDO PARTE BAJA
        CLRA                ;A=0
        ADC     SUMAT       ;A+[SUMAT]+C->A 
        STA     SUMAT       ;A->[SUMAT] GUARDO CARRY EN PARTE ALTA
        INCX                ; ACTUALIZO PUNTERO DE TABLA
        CPX     #BYTES      ; COMPARA X CON 64
        BNE     CICLO       ; SI X ES DISTINTO DE 64 -> CICLO
        RTS                 ; FIN SUBRUTINA SUMA

;--------------SUB. DIVISION----------------
DIVI    LDA     #!6
        STA     CUENTA
        LDX     SUMAT
        LDA     SUMAT+1
        CLR     PROMF
OTRO    LSRX
        RORA
        ROR     PROMF
        DEC     CUENTA
        BNE     OTRO
        RTS

;-------------BIN2BCD----------------------

BIN2BCD NOP
        RTS


;----------------Reset------------------
        ORG     Reset
        FDB     EJ19