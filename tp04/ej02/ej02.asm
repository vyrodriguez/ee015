;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     1
VAR2    RMB     1
VAR3    RMB     1
VAR4    RMB     1
;-----------------PROCESO----------------
        ORG     ROM
inicio  CLR     VAR3
        CLR     VAR4
        LDA     VAR1
        ADD     VAR2
        STA     VAR3
        BCC     nocar
        BSET    1,VAR4        
nocar   BRA     inicio      

;----------------Reset------------------
        ORG     Reset
        FDB     inicio