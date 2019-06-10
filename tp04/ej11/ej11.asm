;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM

;-----------------PROCESO----------------
        ORG     ROM
inicio      

;----------------Reset------------------
        ORG     Reset
        FDB     inicio