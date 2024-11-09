; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores


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
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input	


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

MainLoop
; ****************************************
; Escrever código que lê o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************
	B 	MainLoop
	BL 	PortJ_Input 				 ;Inicia lendo o pushbutton e toma a medida a partir da leitura

VerificaNenhuma
	CMP R0, #2_00000001			 	 ;Caso pb não esteja ativo, desliga o led e volta pro main loop
	BNE VerificaUma
	MOV R0, #0
	BL 	PortN_Output
	B 	MainLoop

VerificaUma
	CMP R0, #2_00000000 		 	 ;Caso pb esteja ativo, chama a função piscaLed
	BNE MainLoop
	BL 	Pisca_LED
	B 	MainLoop
	
;--------------------------------------------------------------------------------
; Função Pisca_LED
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Pisca_LED
; ****************************************
; Escrever função que acende o LED, espera 1 segundo, apaga o LED e espera 1 s
; Esta função deve chamar a rotina SysTick_Wait1ms com o parâmetro de entrada em R0
; ****************************************
	MOV 	R0, #2_1 					 ; Valor do bit do pb no port para acender
	PUSH	{LR}						 ; Salva o retorno do link register para não perder fluxo
	BL PortN_Output						 ; Liga o Led
	MOV 	R0, #1000					 ; Seta quantidade de 1ms para esperar
	BL SysTick_Wait1ms					 ; Espera 1s
	MOV 	R0, #2_0 					 ; Apagar o bit do led
	BL PortN_Output						 ; Desliga led
	MOV 	R0, #1000 					 ; Seta a quantidade de 1ms para esperar
	BL SysTick_Wait1ms					 ; Espera 1s
	POP 	{LR}						 ; Retorna o LinkRegister
	BX LR
	
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
