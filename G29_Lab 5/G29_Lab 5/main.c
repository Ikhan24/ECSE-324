#include <stdlib.h>

#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

char keysPressed[8] = {};
float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};


double getSampleOld(float freq, int t) {

	int index = (((int)freq) * t)%48000;
	double signal = sine[index];

	return signal;
}


double getSample(float freq, int t) {
	int Index_2 = ((int) freq)*t;
	double fractional = (freq*t) - Index_2;

	int index = Index_2 % 48000;
	double signal = (1.0 - fractional) * sine[index] + fractional * sine[index + 1]; 


	return signal;
}


double generateSignal(char* keys, int t) {
	int i;
	double data = 0;
	for(i = 0; i < 8; i++){
		if(keys[i] == 1){
			data += getSampleOld(frequencies[i], t);
			//data += getSample(frequencies[i], t);// overflow
		}
	}
	return data;
}



int main() {
	// Setup timer
	int_setup(1, (int []){199});
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; //microsecond timer
	hps_tim.timeout = 20; //1/48000 = 20.8
	hps_tim.LD_en = 1; // initial count value
	hps_tim.INT_en = 1; //enabling the interrupt
	hps_tim.enable = 1; 

	HPS_TIM_config_ASM(&hps_tim);
	
	char keyReleased = 0;
	int t = 0;
	double history[320] = { 0 };

	char value;

	char amplitude = 1;
	double signalSum = 0.0;


	while(1) {
	
				if (read_ps2_data_ASM(&value)) {
					switch (value){
				// A = C = 130.813Hz
						case 0x1C:
							if(keyReleased == 1){
								keysPressed[0] = 0;
								keyReleased = 0;
							} else{
								keysPressed[0] = 1;
							}
							break;
				// S = D = 146.832Hz
						case 0x1B:
							if(keyReleased == 1){
								keysPressed[1] = 0;
								keyReleased = 0;
							} else{
								keysPressed[1] = 1;
							}
							break;
				// D = E = 164.814Hz
						case 0x23:
							if(keyReleased == 1){
								keysPressed[2] = 0;
								keyReleased = 0;
							} else{
								keysPressed[2] = 1;
							}
							break;
				// F = F = 174.614Hz
						case 0x2B:
							if(keyReleased == 1){
								keysPressed[3] = 0;
								keyReleased = 0;
							} else{
								keysPressed[3] = 1;
							}
							break;
				// J = G = 195.998Hz
						case 0x3B:
							if(keyReleased == 1){
								keysPressed[4] = 0;
								keyReleased = 0;
							} else{
								keysPressed[4] = 1;
							}
							break;
				// K = A = 220.000Hz
						case 0x42:
							if(keyReleased == 1){
								keysPressed[5] = 0;
								keyReleased = 0;
							} else{
								keysPressed[5] = 1;
							}
							break;
				// L = B = 246.942Hz
						case 0x4B:
							if(keyReleased == 1){
								keysPressed[6] = 0;
								keyReleased = 0;
							} else{
								keysPressed[6] = 1;
							}
							break;
				// ; = C = 261.626Hz
						case 0x4C:
							if(keyReleased == 1){
								keysPressed[7] = 0;
								keyReleased = 0;
							}else{
								keysPressed[7] = 1;
							}
							break;
						//volume up 
						case 0x49:
							if(keyReleased == 1){
								if(amplitude<10)
									amplitude++;
								keyReleased = 0;
							}
							break;
						//volume down
						case 0x41:
							if(keyReleased == 1){
								if(amplitude>0)
									amplitude--;
								keyReleased = 0;
							}
							break;
						case 0xF0: 
							keyReleased = 1;
							break;
						default:
							keyReleased = 0;
					}
				}
			
			

			signalSum = generateSignal(keysPressed, t); //generate the signal at this t based on what keys were pressed

			signalSum = amplitude * signalSum; //this is volume control

			// Every 20 microseconds this flag goes high
			if(hps_tim0_int_flag == 1) {
				hps_tim0_int_flag = 0;
				audio_write_data_ASM(signalSum, signalSum);
				t++;
			}

			int drawIndex = 0;
			double valToDraw = 0;
			
			if((t%10 == 0)){
				drawIndex = (t/10)%320;
				VGA_draw_point_ASM(drawIndex, history[drawIndex], 0);
				valToDraw = 120 + signalSum/500000;
				history[drawIndex] = valToDraw;
				VGA_draw_point_ASM(drawIndex, valToDraw, 63);		
			}
			
			// Reset the signal
			signalSum = 0;
			// Reset the counter
			if(t==48000){
				t=0;
			}
		
	}


	return 0;
}
