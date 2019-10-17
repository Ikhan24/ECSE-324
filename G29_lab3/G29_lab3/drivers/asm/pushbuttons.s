							.text
							.equ DATA, 0xFF200050
							.equ EDGECAPTURE, 0xFF20005C
							.equ INTERRUPT, 0xFF200058
							.global read_PB_data_ASM
							.global PB_data_is_pressed_ASM
							.global read_PB_edgecap_ASM
							.global PB_edgecap_is_pressed_ASM
							.global PB_clear_edgecp_ASM
							.global enable_PB_INT_ASM
							.global disable_PB_INT_ASM




read_PB_data_ASM:			LDR R1, =DATA
							LDR R0, [R1]
							BX LR

PB_data_is_pressed_ASM: 	CMP R0, #8	//If pb data 8 branch
							BGE ISP3	
							CMP R0, #4	//If 4 branch
							BGE ISP2
							CMP R0, #2	//If 2
							BGE ISP1
							CMP R0, #1	//If 1
							BGE ISP0
							
							MOV R0, #4	//Else set button to none pressed
							BX LR		

ISP0:						MOV R0, #0	//Return the integer of the button that was pressed (First button = Button 0)
							BX LR

ISP1:						MOV R0, #1	//Return button 1
							BX LR

ISP2:						MOV R0, #2	//Button 2
							BX LR

ISP3:						MOV R0, #3	//Last button, never used
							BX LR
							

read_PB_edgecap_ASM:		LDR R1, =EDGECAPTURE
							LDR R0, [R1]
							BX LR

PB_edgecap_is_pressed_ASM:	MOV R1, #4
							TST R0, #8
							MOVNE R1, #3
							TST R0, #4
							MOVNE R1, #2
							TST R0, #2
							MOVNE R1, #1
							TST R0, #1
							MOVNE R1, #0
							MOV R0, R1
							BX LR

PB_clear_edgecp_ASM:		LDR R1, =EDGECAPTURE
							MOV R2, #0xFFFFFFFF	//Clear all
							STR R2, [R1]
							BX LR

enable_PB_INT_ASM:			LDR R1, =INTERRUPT
							LDR R3, [R1]
							CMP R1, #0		//If R1 is 0, we can store R0 directly
							BEQ STORE0
							ORR R2, R0, R3	//Else we ORR so we do not change other values
							STR R2, [R1]	//Store result
							BX LR

STORE0:						STR R0, [R1]
							BX LR
							

disable_PB_INT_ASM:			LDR R1, =INTERRUPT
							LDR R1, [R1]
							MVN R0, R0	//Take complement of R0
							AND R0, R0, R1	//And it with R1 to not replace unwanted values
							STR R0, [R1]	//Store result
							BX LR

							.end
