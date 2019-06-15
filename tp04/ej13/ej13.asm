;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     3
VAR2    RMB     3
RESU    RMB     4
;-----------------PROCESO----------------
        ORG     ROM
inicio  CLRX
        CLR     RESU,X
        INCX
        CLR     RESU,X
        INCX
        CLR     RESU,X
        INCX
        CLR     RESU,X
        DECX
        CLC
salto   LDA     VAR1,X
        ADC     VAR2,X
        INCX
        STA     RESU,X
        DECX
        DECX
        CPX     #$0
        BNE     salto
        BCC     final
        ROL     $0089
final   BRA     inicio
;----------------Reset------------------
        ORG     Reset
        FDB     inicio