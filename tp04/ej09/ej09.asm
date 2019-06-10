;----------------ETIQUETAS---------------
RAM1    EQU     $0080
RAM2    EQU     $00C0
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM1
TABLA1  RMB     3F

        ORG     RAM2
TABLA2  RMB     3F

;-----------------PROCESO----------------
        ORG     ROM
inicio  CLRX     
mover   LDA     TABLA1,X      
        STA     TABLA2,X
        INCX
        CMPX    #$3F
        BNE     mover
        BRA     inicio     
;----------------Reset------------------
        ORG     Reset
        FDB     inicio