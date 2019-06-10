;-------------------ETIQUETAS-------------------------
RAM         EQU         $0080
ROM         EQU         $EC00
Reset       EQU         $FFFE

;-------------------RAM-------------------------
            ORG         RAM
VAR1        RMB         1
VAR2        RMB         1
VAR3        RMB         1
;-------------------ROM-------------------------
            ORG         ROM
inicio      LDA         VAR1
            CMP         VAR2
            BGE         mayor
            LDA         VAR2
mayor       STA         VAR3
            BRA         inicio
;-------------------Reset-------------------------
            ORG         Reset
            FDB         inicio