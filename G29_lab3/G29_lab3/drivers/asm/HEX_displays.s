							.text
							.equ HEX3_to_HEX0, 0xFF200020
							.equ HEX5_to_HEX4, 0xFF200030
							.global HEX_clear_ASM
							.global HEX_flood_ASM
							.global HEX_write_ASM

HEX_clear_ASM: 				LDR R1, =HEX3_to_HEX0
							MOV R3, #1				//Used to compare 
							MOV R4, #0				//CTR

LOOP1:						CMP R4, #4				//Make sure only looped 3 times
							BGE ENDLOOP1			//Set up for HEX5_4
							TST R0, R3				//AND with R3
							BNE CLEAR				//If not equal clear
							LSL R3, R3, #1			//Left shift comparison value (one hot)
							ADD R4, R4, #1			//Increment CTR
							B LOOP1

CLEAR:						ADD R5, R4, R1			//Get next HEX location in memory
							MOV R7, #0			
							STRB R7, [R5]			//Store 0 into location
							LSL R3, R3, #1			//left shift comparison value
							ADD R4, R4, #1			//Increment counter
							B LOOP1

ENDLOOP1:					LDR R2, =HEX5_to_HEX4	//Memory location for Hex5 and Hex4	
							MOV R4, #0				//Reset counter
	
LOOP2:						CMP R4, #2				//Check if done			
							BXGE LR					//If done, end method
							TST R0, R3				//Compare HEX to one-hot value
							BNE CLEAR2				//If not equal, clear
							LSL R3, R3, #1			//Leftshift
							ADD R4, R4, #1			//Increment counter
							B LOOP2

CLEAR2:						ADD R5, R4, R2			//Get next HEX location in memory
							MOV R7, #0
							STRB R7, [R5]			//Store 0 into location
							LSL R3, R3, #1
							ADD R4, R4, #1
							B LOOP2					

HEX_flood_ASM:				LDR R1, =HEX3_to_HEX0
							MOV R3, #1				//Used to compare 
							MOV R4, #0				//CTR

LOOPF1:						CMP R4, #4				//Make sure only looped 3 times
							BGE ENDLOOPF1	
							TST R0, R3				//AND with R3
							BNE FLOOD				//If not equal FLOOD
							LSL R3, R3, #1			//Left shift
							ADD R4, R4, #1			//Increment Counter
							B LOOPF1

FLOOD:						ADD R5, R4, R1			//Get next location in memory of HEX
							MOV R7, #255	
							STRB R7, [R5]			//Store 255 to memory
							LSL R3, R3, #1			//Leftshift
							ADD R4, R4, #1			//Counter
							B LOOPF1

ENDLOOPF1:					LDR R2, =HEX5_to_HEX4	//For HEX 4 and 5
							MOV R4, #0

LOOPF2:						CMP R4, #2				//Do the same as LOOPF1 and FLOOD1
							BXGE LR
							TST R0, R3
							BNE FLOOD2
							LSL R3, R3, #1
							ADD R4, R4, #1
							B LOOPF2

FLOOD2:						ADD R5, R4, R2
							MOV R7, #255
							STRB R7, [R5]
							LSL R3, R3, #1
							ADD R4, R4, #1
							B LOOPF2	
								
HEX_write_ASM:				LDR R2, =HEX3_to_HEX0
							LDR R3, =HEX5_to_HEX4
							MOV R4, #1				//Used to compare to HEX signals
							MOV R5, #0				//Counter

CHECKIF0:					CMP R1, #0				//Check if parameter value is 0
							BNE CHECKIF1			//If not check if 1...
							MOV R1, #63 			//Move value 0111111 into R1 for later use
							B WRITE					//Start writing

CHECKIF1:					CMP R1, #1				//Check if parameter value is 1
							BNE CHECKIF2			//If not check if 2...
							MOV R1, #6 				//Move value 0000110 into R1 for later use
							B WRITE					//Start writing

CHECKIF2:					CMP R1, #2				//Check if parameter value is 2
							BNE CHECKIF3			//If not check if 3...
							MOV R1, #91 			//Move value 1011011 into R1 for later use
							B WRITE					//Start writing

CHECKIF3:					CMP R1, #3				//Check if parameter value is 3
							BNE CHECKIF4			//If not check if 4...
							MOV R1, #79 			//Move value 1001111 into R1 for later use
							B WRITE					//Start writing

CHECKIF4:					CMP R1, #4				//Check if parameter value is 4
							BNE CHECKIF5			//If not check if 5...
							MOV R1, #102 			//Move value 1100110 into R1 for later use
							B WRITE					//Start writing

CHECKIF5:					CMP R1, #5				//Check if parameter value is 5
							BNE CHECKIF6			//If not check if 6...
							MOV R1, #109 			//Move value 1101101 into R1 for later use
							B WRITE					//Start writing

CHECKIF6:					CMP R1, #6				//Check if parameter value is 6
							BNE CHECKIF7			//If not check if 7...
							MOV R1, #125 			//Move value 1111101 into R1 for later use
							B WRITE					//Start writing

CHECKIF7:					CMP R1, #7				//Check if parameter value is 7
							BNE CHECKIF8			//If not check if 8...
							MOV R1, #39 			//Move value 0100111 into R1 for later use
							B WRITE					//Start writing

CHECKIF8:					CMP R1, #8				//Check if parameter value is 8
							BNE CHECKIF9			//If not check if 9...
							MOV R1, #127 			//Move value 1111111 into R1 for later use
							B WRITE					//Start writing

CHECKIF9:					CMP R1, #9				//Check if parameter value is 9
							BNE CHECKIFA			//If not check if 10...
							MOV R1, #111 			//Move value 1101111 into R1 for later use
							B WRITE					//Start writing

CHECKIFA:					CMP R1, #10				//Check if parameter value is A
							BNE CHECKIFB			//If not check if b...
							MOV R1, #119 			//Move value 1110111 into R1 for later use
							B WRITE					//Start writing

CHECKIFB:					CMP R1, #11				//Check if parameter value is b
							BNE CHECKIFC			//If not check if C...
							MOV R1, #124 			//Move value 1111100 into R1 for later use
							B WRITE					//Start writing

CHECKIFC:					CMP R1, #12				//Check if parameter value is C
							BNE CHECKIFD			//If not check if d...
							MOV R1, #57 			//Move value 0111001 into R1 for later use
							B WRITE					//Start writing

CHECKIFD:					CMP R1, #13				//Check if parameter value is d
							BNE CHECKIFE			//If not check if E...
							MOV R1, #94 			//Move value 1011110 into R1 for later use
							B WRITE					//Start writing

CHECKIFE:					CMP R1, #14				//Check if parameter value is E
							BNE CHECKIFF			//If not check if F...
							MOV R1, #121 			//Move value 1111001 into R1 for later use
							B WRITE					//Start writing

CHECKIFF:					CMP R1, #15				//Check if parameter value is F
							BXNE LR					//If not return...
							MOV R1, #113 			//Move value 1110001 into R1 for later use
							B WRITE					//Start writing

WRITE:						CMP R5, #4				//Check if out of range HEX0-HEX3
							BGE ENDWRITE1			//If yes, setup for HEX4-HEX5
							TST R0, R4				//AND HEX with R4 
							BNE WRITETOHEX3_0		//If not equal, we can write
							LSL R4, R4, #1			//Left shift comparison value
							ADD R5, R5, #1			//Increment counter
							B WRITE					//Loop again

WRITETOHEX3_0:				ADD R6, R5, R2			//Move location of next HEX value into R6
							MOV R7, R1				//Move value to write into R7
							STRB R7, [R6]			//Store written value into memory of HEX value
							LSL R4, R4, #1			//Left shift comparison value
							ADD R5, R5, #1			//Increment counter
							B WRITE					//Go back to write loop

ENDWRITE1:					MOV R5, #0				//Reset counter

WRITE2:						CMP R5, #2				//Check if done range HEX-HEX5
							BXGE LR					//If done, we can exit method and return to caller
							TST R0, R4				//Compare HEX with comparison value
							BNE WRITETOHEX5_4		//If not equal, we can write to HEX4-5
							LSL R4, R4, #1			//Left shift compaison value
							ADD R5, R5, #1			//Increment counter
							B WRITE2				//Loop again

WRITETOHEX5_4:				ADD R6, R5, R3			//Move location of next HEX value into R6
							MOV R7, R1				//Move value to write into R7
							STRB R7, [R6]			//Store written value into memory of HEX value
							LSL R4, R4, #1			//Left shift comparison value
							ADD R5, R5, #1			//Increment counter
							B WRITE2				//Loop to write2					

							.end

