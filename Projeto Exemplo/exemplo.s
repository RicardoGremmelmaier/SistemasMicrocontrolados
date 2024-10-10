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
	MOV  R0, #65           ; A
	
	MOV  R1, #0x1B00       ; B
	MOVT R1, #0x1B00       ; B
	
	LDR  R2, =0x12345678   ; C - MOV R2, #0X5678, MOVT R2, #0X1234
	
	LDR  R3, =0x20000000   ; D
	STR  R0, [R3, #0x40]   ; D
	
	STR  R1, [R3, #0x44]   ; E
	
	STR  R2, [R3, #0x48]   ; F
	
	LDR  R4, =0xF0001      ; G
	STR  R4, [R3, #0x4C]   ; G
	
	MOV  R5, 0xCD; H
	STRB R5, [R3, #0x46]   ; H
	
	LDR  R7, [R3, #0x40]   ; I
	
	LDR  R8, [R3, #0x48]   ; J
	
	MOV  R9, R7			   ; K
	
	NOP

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
