;----------------ETIQUETAS---------------
<<<<<<< HEAD:tp04/ej1/ej1.asm
RAM         EQU         $0080
ROM         EQU         $EC00
Reset       EQU         $FFFE

;-------------------RAM-------------------------
            ORG         RAM
VAR1        RMB         1
VAR2        RMB         1
RESU        RMB         1

;-------------------ROM-------------------------
            ORG         ROM
inicio      CLR         RESU
            LDA         VAR1
            EOR         VAR2
            EOR         #$FF
            STA         RESU
            BRA         inicio

;-------------------Reset-------------------------
            ORG         Reset
            FDB         inicio
=======
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
>>>>>>> cb61fd8be13be6140600ad6a73929ecc1f6ba632:tp04/ej02/ej02.asm
