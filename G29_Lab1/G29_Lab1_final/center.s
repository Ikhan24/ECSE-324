				.text
		    	.global _start

_start:
				MOV R4, #0 				//R4 acts as our sum variable
				LDR R3, =N				//R3 has the address of the list
				LDR R1, [R3]			//R1 has the size of the list
				LDR R11, [R3]
				ADD R0, R3, #4 			//R0 acts as a pointer to the next element in the list
			
SUM:			
				LDR R2, [R0]			//R2 holds the first element in the list
				ADD R4, R4, R2			//We add the first element in the list to R4
				SUBS R1, R1, #1			//Decrease size of R1 by 1, it acts as our counter
				BEQ START				//When we have reached the end of the list, go to CENTER
				ADD R0, R0, #4			//R0 is updated to point to next element
				BNE SUM					//Go back
				
START:			MOV R6, #0
CENTER:			
				LSR	R11, R11, #1		//This label essentially gets the value of 'N' needed to do the final shift amount
				ADD R6, R6,	#1			//We load the size of the list, and shift to the right until we hit 1
				CMP R11, #1				//We add the amounts of the shifts to a counter and than check until the counter's 1
				BEQ	DONE				//When it is, we simply get the value of times we need to shift, and we exit
				B CENTER				//If n != 1, go back

DONE: 			MOV R5, R4				//R5 also has the sum of our list
				ASR R5, R5, R6 			//Calculate the average, store back in R5. We use ASR to handle negative signal lengths.
				
				LDR R7, =N 				//R7 has the address of list
				LDR R8, [R7]			//R8 has the size
				ADD R9, R7, #4			//R9 acts as a pointer to the first element in the list

SUBSTRACTION:	
				LDR R10, [R9] 			//R10 is loaded the first element
				SUB R10, R10, R5 		//We the average from each element in the list
				STR R10, [R9]			//Store it back in memory
				SUBS R8, R8, #1			//Decrease the counter
				ADD R9, R9, #4			//Update R9 so that it points to the next element's address
				BEQ END					//If counter is indeed 0, exit
				B SUBSTRACTION			//Go back to start of subtraction

END:			B END

RESULT:			.word	0				//Memory assigned for result location
N:				.word	8				//Number of entries in the list
NUMBERS: 		.word 	4, 5, 3, 6  	//The list data
				.word	1, 8, 2, 0

 