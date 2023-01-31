/*
 * note.c
 *
 *  Created on: Nov 16, 2021
 *      Author: Byron Lathi
 */

#include "note.h"
#include <stdlib.h>

long long get_notetime_ms(int beats){
	long long note_ms = 0;


	int last_timechange = 0;
	while (beats > timechange_beat[last_timechange] && last_timechange < time_changes) last_timechange++;
	--last_timechange;	//kind of a hack, since we know that the first "timechange" is actually at 0.

	note_ms += timechange_ms[last_timechange];


	long long note_offset = beats - timechange_beat[last_timechange];		//beats since last keychange

	long long time_offset = ( MS_PER_MIN *  note_offset)/(tempo[last_timechange] * resolution);	//resolution is 192

	note_ms += time_offset;			//and that is the final time of the note.

	return note_ms;
}
