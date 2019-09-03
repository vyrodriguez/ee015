;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
;----------------VARIABLES---------------
        ORG     RAM
VAR1    RMB     1     ; 1 BYTE
VAR2    RMB     1     ; VAR2 -> LSB
VAR3    RMB     1     ; VAR3 -> MSB
;-----------------PROCESO----------------
            ORG     ROM
inicio      CLR     VAR2
            CLR     VAR3
            LDA     VAR1    ;CARGA AL ACUMULADOR EL CONT. VAR1
            LSLA            ;CORRIMIENTO A LA IZQUIERDA
            ROL     VAR3  ;EL C_OUT PASA AL 'LSB' Y LO QUE ESTABA EN 'MSB' PASA A C_IN
            LSLA
            ROL     VAR3
            STA     VAR2  ;ALMACENO EN LSB
            BRA     inicio
;----------------Reset------------------
            ORG     Reset
            FDB     inicio