;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     1
VAR2    RMB     1
VAR3    RMB     1
;-----------------PROCESO----------------
        ORG     ROM
inicio  LDA     VAR1
        EORA    VAR2
        STA     VAR3
        BRA     inicio
;----------------Reset------------------
        ORG     Reset
        FDB     inicio