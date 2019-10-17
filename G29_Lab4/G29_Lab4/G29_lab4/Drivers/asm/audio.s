		.text
		.equ Fifospace, 0xFF203044 
		.equ Leftdata, 0xFF203048
		.equ Rightdata, 0xFF20304C //in manual it is 3C but should be 4C
		.global audio_port
audio_port:
	LDR R1, = Fifospace

	LDRB R2, [R1, #2] //accessing the second byte(WSRC) in R1 and putting it into R2 
	CMP R2, #0 //Checking if there is space at WSRC
	BEQ audio_end // if not return 0 by branching to audio_end

	LDRB R3, [R1, #3] //accessing the third byte(WSLC) in R1 and putting it into R2
	CMP R3, #0 //Checking if there is space at WSLC
	BEQ audio_end // if not return 0 by branching to audio_end

	LDR R2, = Leftdata
	LDR R3, = Rightdata
	STR R0, [R2] // Writing it to the left FIFO
	STR R0, [R3] // Writing it to the right FIFO

	MOV R0, #1 // returns an integer value of 1 after data is written
	BX LR

audio_end: 
	MOV R0, #0 // returns 0 when data is not written
	BX LR

	
