; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000	


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
									

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Inicializar as portas J e N
; ****************************************
; Ativar os clocks e verificar se estão ativos - RCGCPIO e PRGPIO

			LDR			R0, =SYSCTL_RCGCGPIO_R            ; Carrega endereço do registrador RCGCPIO
			MOV 		R1, #GPIO_PORTN                   ; Seta bits da porta N
			ORR 		R1, #GPIO_PORTJ					  ; Seta bits da porta J também, utilizando OR
			STR 		R1, [R0]						  ; Seta na memória do RCGCPIO os bits das portas
			
			LDR 		R0, =SYSCTL_PRGPIO_R              ; Carrega endereço do registrador PRGPIO
EsperaGPIO 	LDR 		R1, [R0]						  ; Lê da memória o conteúdo do endereço do registrador
			MOV 		R2, #GPIO_PORTN 				  ; Seta bits da porta N
			ORR 		R2, #GPIO_PORTJ					  ; Seta bits da porta J
			TST 		R1, R2 							  ; ANDS de R1 com R2
			BEQ 		EsperaGPIO                        ; Quando for diferente de zero, os bits do PRGPIO foram setados
			
; Limpar o AMSEL
			MOV 		R1, #0x00						  ; Coloca 0 no registrador para desabilitar função analógica
			LDR 		R0, #GPIO_PORTJ_AHB_AMSEL_R		  ; Coloca o endereço do AMSEL para o port J
			STR 		R1, [R0]						  ; Zera os bits do AMSEL da porta J
			LDR 		R0, ##GPIO_PORTN_AHB_AMSEL_R	  ; Coloca o endereço do AMSEL para o port N
			STR 		R1, [R0]						  ; Zera os bits do AMSEL da porta N
	
; Limpar PCTL
			MOV 		R1, #0x00 						  ; Coloca 0 no registrador para selecionar o modo GPIO
			LDR 		R0, =GPIO_PORTJ_AHB_PCTL_R		  ; Coloca o endereço do PCTL da porta J
			STR 		R1, [R0] 						  ; Zera os bits do PCTL da porta J
			LDR 		R0, =GPIO_PORTN_AHB_PCTL_R		  ; Coloca o endereço do PCTL da porta N
			STR 		R1, [R0]						  ; Zera os bits do PCTL da porta N
			
; DIR 0 para entrada e DIR 1 para saída
			
			BX LR 

; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	
	BX LR
; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	
	BX LR



    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo