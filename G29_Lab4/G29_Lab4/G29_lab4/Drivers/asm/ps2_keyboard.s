	.text
	.equ PS2_base, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:
	LDR R1, = PS2_base
	LDR R1, [R1]

	AND R2, R1, #0b1000000000000000
	CMP R2, #0
	BEQ read_PS2_data_end
	STRB R1, [R0]
	MOV R0, #1
	BX LR 

read_PS2_data_end:
	MOV R0, #0
	BX LR
	.end
