;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     1
TABLA   RMB     $10
VAR2    RMB     1
;-----------------PROCESO----------------
        ORG     ROM
inicio  CLRX
        CLR     VAR2
        LDA     VAR1
        CMP     #$10
        BLS     eval
        CLR     VAR2
        BRA     inicio
eval    CPX     VAR1
        BEQ     escri
        INCX
        CPX     #$F
        BNE     eval
escri   LDA     TABLA,X
        STA     VAR2
        BRA     inicio

;----------------Reset------------------
        ORG     Reset
        FDB     inicio