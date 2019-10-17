#include <stdio.h>

#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/vga.h"
#include "./drivers/inc/ps2_keyboard.h"

int main (){
	int x =0;
	int y =0;
	int pushButton;
	char *data;
	while (1){
		pushButton= read_PB_data_ASM();
		if (pushButton== PB0){
			VGA_clear_charbuff_ASM();
			x=0;
			y=0;
			}

		else if (read_PS2_data_ASM(data)){
			VGA_write_byte_ASM(x,y,*data);
			x= x+3;
			if(x>79){
				x=0;
				y++;
				if(y>59){
					y=0;
					VGA_clear_charbuff_ASM();
					}
				}
			}
		}
	}
