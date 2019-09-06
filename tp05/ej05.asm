;----------------ETIQUETAS---------------
RAM     EQU     $0080
ROM     EQU     $EC00
Reset   EQU     $FFFE
PUERTOA EQU     $0000
DDRA    EQU     $0004
Config1 EQU     $001F

; --------------------------------
; | 7 | 6 | 5 | 4 | 3 | 2| 1 | 0 | Registro Config1
; --------------------------------
;----------------VARIABLES---------------
                ORG     RAM
error           RMB     1               ;  Variable error (1 byte)

;-----------------PROCESO----------------
            ORG         ROM
            RSP                         ;   Reinicio puntero de pila
            BSET        0,Config1       ;   Deshabilita Modulo COP
            BSR         INIPUERTOS      ;   Ejecuta subrutina configuracion
            BSR         INIVAR          ;   Ejecuta subrutina iniciar variables
LOOP        BSR         PULSADO         ;   Ejecuta subrutina pulsado
            BSR         LED             ;   Ejecuta subrutina led
            BRA         LOOP            ;   Repite Loop

;--------------- INIPUERTOS --------------
INIPUERTOS  LDA         #$FF
            STA         PUERTOA         ;   Escribo registro puerto a
            LDA         #%11011111      ;   Cargo en 'A' configuracion
            STA         DDRA            ;   Configuro PA0...PA4 -> salida, PA5 <- entrada
            RTS 
;--------------- INIVAR --------------

            CLR         error           ;   Error = 0
            RTS
;--------------- PULSADO --------------
PULSADO     LDA         PUERTOA         ;   Leo puerto a
            BIT         #%00100000      ;   Test BIT5
            BNE         PULSADO         ; Si Z=0 => PULSADO
            BSR         RETARDO         ; Subrutina Retardo
            LDA         PUERTOA         ; LED PUERTOA
            BIT         #%00100000      ; TEST BIT5
            BNE         Error           ; Si PA5==1 -> Error
            LDA         PUERTOA         ; Leo puerto a
            BIT         #%00100000      ; Test BIT5
            BEQ         Error           ; PA5==0 -> Error
            CLRA                        ; A==0
            BRA         FIN
;--------------- ERROR --------------
Error       LDA         #$FF
FIN         STA         error
            RTS
;--------------- LED --------------
LED         LDA         error
            BNE         NOPULSO
            LDA         PUERTOA
            EOR         #%00000001
            STA         PUERTOA
NOPULSO     RTS
;--------------- RETARDO --------------
RETARDO     NOP
            RTS

     

;----------------Reset------------------
        ORG     Reset
        FDB     inicio