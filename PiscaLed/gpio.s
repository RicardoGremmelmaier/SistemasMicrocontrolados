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
			LDR 		R0, =GPIO_PORTJ_AHB_AMSEL_R		  ; Coloca o endereço do AMSEL para o port J
			STR 		R1, [R0]						  ; Zera os bits do AMSEL da porta J
			LDR 		R0, =GPIO_PORTN_AHB_AMSEL_R	 	  ; Coloca o endereço do AMSEL para o port N
			STR 		R1, [R0]						  ; Zera os bits do AMSEL da porta N
	
; Limpar PCTL
			MOV 		R1, #0x00 						  ; Coloca 0 no registrador para selecionar o modo GPIO
			LDR 		R0, =GPIO_PORTJ_AHB_PCTL_R		  ; Coloca o endereço do PCTL da porta J
			STR 		R1, [R0] 						  ; Zera os bits do PCTL da porta J
			LDR 		R0, =GPIO_PORTN_AHB_PCTL_R		  ; Coloca o endereço do PCTL da porta N
			STR 		R1, [R0]						  ; Zera os bits do PCTL da porta N
			
; DIR 0 para entrada e DIR 1 para saída
			LDR 		R0, =GPIO_PORTN_AHB_DIR_R 		  ; Coloca o endereço do DIR para o port N (led)
			MOV 		R1, #2_00000001					  ; PN0 ativo, saída do LED
			STR 		R1, [R0]						  ; Coloca esse bit de saída no DIR
			
			LDR 		R0, =GPIO_PORTJ_AHB_DIR_R		  ; Coloca o endereço do DIR para o port J (push button)
			MOV 		R1, #0x00						  ; Todos os bits são entrada, só usaremos o PJ0
			STR 		R1, [R0]						  ; Coloca todos os bits como entrada

; Limpar o AFSEl para não ter função alternativa
			MOV     R1, #0x00							  ; Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTN_AHB_AFSEL_R			  ; Carrega o endereço do AFSEL da porta N
            STR     R1, [R0]							  ; Limpa os bits
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R    	      ; Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        	  ; Limpa os bits

; Setar o DEN para habilitar os pinos digitais
			LDR 	R0, =GPIO_PORTN_AHB_DEN_R			  ; Carrega o endereço do DEN para a porta N
			MOV 	R1, #00000001						  ; Ativa a PN0 para ser digital
			STR		R1, [R0]							  ; Seta o bit digital para PN0
			LDR 	R0, =GPIO_PORTJ_AHB_DEN_R			  ; Carrega o endereço do DEN para a porta J
			MOV 	R1, #00000001						  ; Ativa a PJ0 para ser digital
			STR		R1, [R0]							  ; Seta o bit digital para PJ0
			
; Habilitar resistor pull up para o push button
			LDR 	R0, =GPIO_PORTJ_AHB_PUR_R 			  ; Carrega o endereço do PUR para a porta J
			MOV 	R1, #2_00000001					  ; Seta o bit do PJ0 para utilizar o PUR
			STR 	R1, [R0]							  ; Salva o bit setado no PUR da porta J
			
; fim do setup dos registradores
			BX LR 

; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: R0 -> Se o BIT0 da
; Parâmetro de saída: Não tem
PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R1, =GPIO_PORTN_AHB_DATA_R 		; Le o endereço do data
	LDR R2, [R1] 						; Pega o valor do data
	BIC R2, #2_00000001					; Limpa o bit0, que vamos ler
	ORR R0, R0, R2					    ; Faz o OR pra salvar o novo bit 
	LDR R0, [R1]						; Escreve na porta o novo valor, com o bit salvo
	
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
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados o pino [J0]
	
	BX LR



    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo