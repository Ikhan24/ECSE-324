#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"

int main(){
	
	HPS_TIM_config_t hps_tim0;
	HPS_TIM_config_t hps_tim1;

	part1();		//Uncomment to use part 1 - flood/clear/write
	//part2(hps_tim0, hps_tim1);	//Uncomment to use part 2 - io
	

	return 0;
}

int part1(){
	while(1){
		
		write_LEDs_ASM(read_slider_switches_ASM());	//Light up LED when switches turned on
		//HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);		
		HEX_flood_ASM(HEX4|HEX5);	//Flood last 2
	
		
		switch(PB_data_is_pressed_ASM(read_PB_data_ASM())){		//Get button number that is pressed
			case 0:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX0, read_slider_switches_ASM());	//If 1, display on hex0
				break;
			case 1:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX1, read_slider_switches_ASM());	//If 2, display on hex1
				break;
			case 2:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX2, read_slider_switches_ASM());	//If 3, display on hex2
				break;
			case 3:
				HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
				HEX_write_ASM(HEX3, read_slider_switches_ASM());	//If 4, display on hex3
				break;	
		}		
		
		if(read_slider_switches_ASM() >= 512){	//2^9 for switch 9
			HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5);	//Clear all
		}
	}
	return 0;
}

int part2(HPS_TIM_config_t hps_tim0, HPS_TIM_config_t hps_tim1){

	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;	//Set counters for minutes, seconds, millis
	int start = 0;	//Do not start if button not pressed

	hps_tim0.tim = TIM0;
	hps_tim0.timeout = 10000; //For timer
	hps_tim0.LD_en = 1;
	hps_tim0.INT_en = 1;
	hps_tim0.enable = 1;

	hps_tim1.tim = TIM1;
	hps_tim1.timeout = 5000;	//For buttons
	hps_tim1.LD_en = 1;
	hps_tim1.INT_en = 1;
	hps_tim1.enable = 1;

	HPS_TIM_config_ASM(&hps_tim0);
	HPS_TIM_config_ASM(&hps_tim1);

	HEX_write_ASM(HEX0|HEX1|HEX2|HEX3|HEX4|HEX5, 0);	//Set all to 0
	
	while(1){

		if(start){	//Only run stopwatch if program started
				
			if(HPS_TIM_read_INT_ASM(TIM0)){	//Read for timer
				HPS_TIM_clear_INT_ASM(TIM0);
				if(++count0 == 10){		//Increment last digit until reaches 10, then increment next digit
					count0=0;
					count1++;
				}
				if(count1 == 10){	//Increment digit until reaches 10, then increment next digit
					count1=0;
					count2++;
				}
				if(count2 == 10){	//Increment digit until reaches 10, then increment next digit
					count2=0;
					count3++;
				}
				if(count3 == 6){ //Increment digit until reaches 10, then increment next digit
					count3=0;
					count4++;
				}
				if(count4 == 10){ //Increment digit until reaches 6, then increment next digit
					count4=0;
					count5++;
				}
				if(count5 == 6){ //Increment digit until reaches 6, then reset since we reached 60 min
					count5=0;
				}
			
				HEX_write_ASM(HEX0, count0);
				HEX_write_ASM(HEX1, count1);
				HEX_write_ASM(HEX2, count2);
				HEX_write_ASM(HEX3, count3);
				HEX_write_ASM(HEX4, count4);
				HEX_write_ASM(HEX5, count5);	//Write all digits to their screens
			}
		}

		if(HPS_TIM_read_INT_ASM(TIM1)){	//Read for buttons
			HPS_TIM_clear_INT_ASM(TIM1);

			if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 0)	//If button 1 is pressed, the program starts/resumes
				start = 1;

			if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 1){	//If button 2 is pressed, the program pauses
				start = 0;
				while(1){	//The program only breaks from the loop and continues if start or reset are pressed
					if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 0 || PB_data_is_pressed_ASM(read_PB_data_ASM()) == 2){
						start = 1;
						break;
					}
				}	
			}
			if(PB_data_is_pressed_ASM(read_PB_data_ASM()) == 2){	//If reset is pressed all counts are set to 0 on the displays
				count0 =0;
				count1=0;
				count2=0;
				count3=0;
				count4=0;
				count5=0;

				HEX_write_ASM(HEX0, count0);
				HEX_write_ASM(HEX1, count1);
				HEX_write_ASM(HEX2, count2);
				HEX_write_ASM(HEX3, count3);
				HEX_write_ASM(HEX4, count4);
				HEX_write_ASM(HEX5, count5);
			}
		}
	}
	return 0;
}


