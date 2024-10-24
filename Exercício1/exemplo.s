; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()
Start  
; Comece o código aqui <======================================================

;Exercicio1
;	MOV  R0, #65           ; A
;	
;	MOV  R1, #0x1B00       ; B
;	MOVT R1, #0x1B00       ; B
;	
;	LDR  R2, =0x12345678   ; C - MOV R2, #0X5678, MOVT R2, #0X1234
;	
;	LDR  R3, =0x20000000   ; D
;	STR  R0, [R3, #0x40]   ; D
;	
;	STR  R1, [R3, #0x44]   ; E
;	
;	STR  R2, [R3, #0x48]   ; F
;	
;	LDR  R4, =0xF0001      ; G
;	STR  R4, [R3, #0x4C]   ; G
;	
;	MOV  R5, 0xCD; H
;	STRB R5, [R3, #0x46]   ; H
;	
;	LDR  R7, [R3, #0x40]   ; I
;	
;	LDR  R8, [R3, #0x48]   ; J
;	
;	MOV  R9, R7			   ; K

;Exercicio2
;	MOV  R12, #0xF0               ; A 
;	ANDS R0 , R12, #2_01010101    ; A
;	
;	MOV  R12, #0x11001100         ; B
;	ANDS R1 , R12, #2_00110111     ; B
;	
;	LDR  R12, =0x2_10000000       ; C
;	ANDS R2 , R12, #2_00110111     ; C
;	
;	MOV  R12, #0xFFFF              ; D
;	LDR  R9 , =0x_ABCDABCD         ; D
;	BICS R3 , R9 , R12              ; D
;	
;Exercicio3	
;	MOV   R0, #701            ; A
;	LSRS  R0, 5               ; A
;	
;	MOV   R1, #32067          ; B
;	NEG   R1, R1              ; B
;	LSRS  R2, R1, 4           ; B

;	MOV   R3, #701            ; C
;	ASRS  R3, 3               ; C
;	
;	ASRS  R4, R1, 4           ; D
;	
;	MOV   R4, #255            ; E
;	LSLS  R4, 8               ; E
;	
;	MOV   R5, #58982          ; F
;	NEG   R5, R5              ; F
;	LSLS  R5, 18              ; F
;	
;	LDR   R6, =0xFABC1234     ; G
;	ROR   R6, 10              ; G
;	
;	MOV   R7, #0x4321         ; H
;	RRXS  R7                  ; H
;	RRXS  R7                  ; H
	
;Exercicio4
;	MOV   R12, #101              ; A
;	ADDS  R0 , R12, #253         ; A
;	
;	MOV   R11, #1500             ; B
;	MOV   R10, #40543            ; B
;	ADD   R1 , R10, R11          ; B
;	
;	MOV   R9 , #340              ; C
;	SUBS  R2 , R9 , #123         ; C
;	
;	MOV   R8 , #1000             ; D
;	SUBS  R3 , R8 , #2000        ; D
;	
;	MOV   R7 , #54378            ; E 
;	MOV   R6 , #4                ; E
;	MUL   R4 , R6 , R7           ; E - similar a essa operação LSL  R4 , R7 , #2 
;	
;	LDR   R12, =0x11223344       ; F
;	LDR   R11, =0x44332211       ; F
;	UMULL R5 , R6 , R11, R12     ; F
;	
;	LDR   R10, =0xFFFF7560       ; G
;	SDIV  R6 , R10, R8           ; G
;	
;	UDIV  R7 , R10, R8           ; H

;Exercicio5
;	MOV   R0 , #10                 ; A
;	
;	CMP   R0 , #9                  ; B
;	
;	ITTE   CS                      ; C
;    MOVCS R1, #50                 ; C.1
;    ADDCS R2, R1, #32             ; C.2
;    MOVCC R3, #75                 ; C.3
;	
;	CMP   R0 , #11                 ; D 
;	ITTE   CS                      ; D
;	 MOVCS R1 , #50                ; D.1
;	 ADDCS R2 , R1 , #32           ; D.2
;	 MOVCC R3 , #75                ; D.3

;Exercicio6	
;	MOV  R0 , #10                   ; A
;	
;	LDR  R1 , =0xFF11CC22           ; B
;	
;	MOV  R2 , #1234                 ; C
;	
;	MOV  R3 , #0x300                ; D
;	
;	PUSH {R0}                       ; E
;	
;	PUSH {R1}                       ; F
;	PUSH {R2}                       ; F
;	PUSH {R3}                       ; F
;	
;	MOV  R1 , #60                   ; H
;	
;	MOV  R2 , #0x1234               ; I
;	
;	POP {R3}                        ; J
;	POP {R2}                        ; J
;	POP {R1}                        ; J
;	POP {R0}                        ; J

Exercicio7
	MOV  R0 , #10                    ; A

Soma5
	ADD  R0 , #5                     ; B
	
	
	CMP  R0 , #50                    ; C
	BNE  Soma5                       ; C
	
	BL Func                          ; D
	NOP                              ; E
	B Fim                            ; F
	
Func
	MOV  R1 , R0                     ; D.1
	
	CMP R1 , #50                     ; D.2
	
	ITEE   CC                        ; D.3
	 ADDCC  R1 , #1                  ; D.3
	 MOVCS  R1 , #50                 ; D.3
	 NEGCS  R1 , R1                  ; D.3
	 
	BX LR                            ; E
	 
Fim
	NOP

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
