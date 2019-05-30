;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     1
VAR2    RMB     1
VAR3    RMB     2
;-----------------PROCESO----------------
        ORG     ROM
inicio  CLR     VAR3+1
        LDA     VAR1
        ADD    VAR2
        STA     VAR3
        ROL     VAR3+1   
        BRA     inicio      

;----------------Reset------------------
        ORG     Reset
        FDB     inicio