#include <stdio.h>

#include "./drivers/inc/audio.h"

//the sample rate provided by the audio CODEC is 48K sample

int sample_rate = 48000;
int frequency = 100;
int samples = 0;
int signal = 0x00FFFFFF; // input makes all 1 to create on signal that would produce sound

int main() {
	while(1){
	//if WSRC and WSLC have spaces then
		if(audio_port(signal)){
		samples = samples +1; //increase the sample
		//printf("%d,\n",samples);
		//printf("%d,\n",signal);
		// square wave so half time 1 and half time 0
		if( samples > (sample_rate/(frequency * 2) )) {
			samples = 0;
			if(signal == 0x00FFFFFF){
				signal = 0x00000000; //when signal 1 make it zero
				}
				else{
					 signal = 0x00FFFFFF; // when signal 0 make it 1
				}
			}
		}
	}	
}
