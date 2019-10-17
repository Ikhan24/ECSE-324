#include <stdio.h>

#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/vga.h"

void test_char(){
	int x, y;
	char c = 0;

	for(y=0; y<=59; y++){
		for(x=0; x<=79; x++){
			VGA_write_char_ASM(x,y,c++);
		}
	}
}

void test_byte(){
	int x,y;
	char c = 0;

	for(y=0; y<=59; y++){
		for(x=0; x<=79; x+=3){
			VGA_write_byte_ASM(x,y,c++);
		}
	}
}

void test_pixel(){
	int x,y;
	unsigned short colour = 0;

	for(y=0; y<=239; y++){
		for(x=0; x<=319; x++){
			VGA_draw_point_ASM(x,y,colour++);
		}
	}
}

int main (){
	while (1){
	

	int sliderSwitch=read_slider_switches_ASM();
	int pushButton= read_PB_data_ASM();
	printf("%d,\n",pushButton);
		if (pushButton== PB0){
			if(sliderSwitch==0) {
				test_char();
			}
			else {
				test_byte();
			}
		}
		 if (pushButton == PB1) {
				test_pixel();
		}
		 if (pushButton == PB2) {
				VGA_clear_charbuff_ASM();
		}
		 if (pushButton == PB3) {
				VGA_clear_pixelbuff_ASM();
		}

	}
}
		



