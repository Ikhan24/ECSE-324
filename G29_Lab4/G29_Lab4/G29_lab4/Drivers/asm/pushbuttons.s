	.text
	.equ PB_DATA, 0xFF200050
	.equ PB_INT, 0xFF200058
	.equ PB_EC, 0xFF20005C

	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM

	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM

	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM

read_PB_data_ASM:
	LDR R1, =PB_DATA
	LDR R0, [R1]
	MOV R2, #0x0000000F
	AND R0, R0, R2
	BX LR

PB_data_is_pressed_ASM:
	LDR R1, =PB_DATA
	LDR R2, [R1]
	AND R0, R2, R0
	BX LR

read_PB_edgecap_ASM:
	LDR R1, =PB_EC
	LDR R0, [R1]
	MOV R2, #0x0000000F
	AND R0, R0, R2
	BX LR

PB_edgecap_is_pressed_ASM:
	LDR R1, =PB_EC
	LDR R2, [R1]
	AND R0, R2, R0
	BX LR

PB_clear_edgecap_ASM:
	LDR R1, =PB_EC
	STR R0, [R1]
	BX LR

enable_PB_INT_ASM:
	LDR R1, =PB_INT
	LDR R2, [R1]
	ORR R0, R2, R0
	STR R0, [R1]
	BX LR

disable_PB_INT_ASM:
	LDR R1, =PB_INT
	LDR R2, [R1]
	BIC R1, R1, R0 
	STR R0, [R1]
	BX LR

	.end
