;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
TABLA   RMB     14
VECES   RMB     1
;-----------------PROCESO----------------
        ORG     ROM
inicio  CLRX
        CLR     VECES
leer    LDA     TABLA,X
        CMP     #%01010100
        BNE     noinc
        INC     VECES
noinc   INCX
        CPX     #$13
        BNE     leer
        BRA     inicio   

;----------------Reset------------------
        ORG     Reset
        FDB     inicio