;----------------ETIQUETAS---------------
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