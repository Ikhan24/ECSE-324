				.text
				.global _start

_start:
				LDR R0, =FIRST		//R0 gets the first memory element
				LDR R1, [R0, #4]	//R1 gets the size of the list
				ADD R4, R0, #8		//R4 acts as pointer to the first element in memory
				MOV R5, #1			//R5 will act both as a counter in our bubble sort function and the flag for outer loop
				MOV R6, #1			//R6 will act as a counter to test against the length of the list

WHILE_LOOP:
				CMP R6, R1			//Compare value of R6 against the size of the list
				BEQ SORTING_DONE	//If condition flags are satisfied, we are at the end, we simply hit the end
				ADD R6, R6, #1		//Increment R6 by 1
				MOV R4, R0			//R4's address gets reset with the start address			
				ADD R4, R4, #8		//R4 acts as a pointer to the first element
				MOV R5, #0			//Reset R5 to 0, here R5 is the flag
				B	BUBBLE_SORT		//Commencing bubble sort

BUBBLE_SORT:
				CMP R5, R1			//R5 as stated previously has a dual role, here it acts as a counter
				BEQ	WHILE_LOOP		//If 0, we go back to the while loop
				ADD R5, R5, #1		//Increment our counter
				LDR R2, [R4]		//We load the contents of current address into R2
				LDR R3, [R4, #4]	//We load the contents of the next address into R3
				CMP	R2, R3			//We compare the contents of R2 and R3
				BGE SWAP			//If R2 >= R3
				ADD R4, R4, #4		//Increment pointer to point to next address
				B BUBBLE_SORT		//Go to bubble sort

SWAP:			
				STR R3, [R4]		//Store R3 into R2's address
				STR R2, [R4, #4]	//Store R2 into R3's address
				ADD R4, R4, #4		//Increment pointer to point to next address
				B BUBBLE_SORT		//Done one round of swapping, go back

SORTING_DONE:			
				LDR R6, =FIRST		//Load first address to check if sorting executed correctly
				LDR R7, [R6, #8]	//If correct, R7 should be 1
				LDR R8, [R6, #36]	//If correct R8 should be 8
				LDR R9, [R6, #12]	//If correct R9 should be 2
				LDR R10,[R6, #20]	//If correct R10, should be 4

END:			B END				//END
	
FIRST:			.word 0
N:				.word 8
NUMBER:			.word 8, 7, 6, 5, 4, 3, 2, 1