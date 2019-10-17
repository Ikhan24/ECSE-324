			.text
		    .global _start

_start:
			LDR R4, =RESULT 	//R4 points to the memory location of result
			LDR R2, [R4, #8]	//Using offset addressing mode, R2 holds size
			ADD R3, R4, #12		//R3 will point to the first element
			LDR R0, [R3] 		//R0 now holds the first element 

LOOP:		SUBS R2, R2, #1		//Decrement the loop counter, i.e reduce size
			BEQ DONE			//end loop if counter has reached, i.e N = 0
			ADD R3, R3, #4		//R3 now points to the next number
			LDR R1, [R3]		//R1 holds the next number
			CMP R0, R1			//Check with the first element
			BGE LOOP			//If no, branch back
			MOV R0, R1			//If yes, replace value in R0	
			B LOOP				//Go back to loop

DONE:		STR R0, [R4]		//Store the result to the memory location

			LDR R6, =RESULT_2	//Store address of first memory element
			LDR R7,	[R6, #4]	//Holds size of the list
			ADD	R9,	R6, #8		//R9 points to next memory element
			LDR R4, [R6, #8]	//Holds first element

MIN_LOOP:
			SUBS R7, R7, #1		//Decrement counter on each pass
			BEQ DONE_2			//If zero, exit
			ADD R9, R9, #4		//Point to next element
			LDR R10, [R9]		//Load contents into R10
			CMP	R4, R10			//Check with R4
			BLE	MIN_LOOP		//Go back
			MOV R4, R10			//Replace contents	
			B	MIN_LOOP		//Go back

DONE_2:		MOV R11, R4			//Move smallest value in R11
			SUB R11, R0, R11	//Subtract value of MAX and MIN
			ASR R11, R11, #2	//Divide by 4, if correct R11 should be 2, because the other bits are dropped. 
END:		B END				//End


RESULT:		.word	0			//Memory assigned for result location
RESULT_2:	.word	0			//Added memory for min calculation
N:			.word	7			//Number of entries in the list
NUMBERS: 	.word 	0, 5, 3, 6  //The list data
			.word	1, 10, 2
