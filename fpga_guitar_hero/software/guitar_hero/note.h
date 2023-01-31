/*
 * note.h
 *
 *  Created on: Nov 16, 2021
 *      Author: byron
 */

#ifndef NOTE_H_
#define NOTE_H_

#include <alt_types.h>

#define MS_PER_MIN 60000000

#define FRETS_Y 420

#define BIT(x) (1<<x)

#define SPEEDHAX 1

#define HYPERSPEED 13
#define NOTE_TIME(x) ((10000*(x))/(480*HYPERSPEED))
#define NOTE_POS(x) ((((x)*HYPERSPEED*480)/10000))

#define B_GREEN		(1 << 0)
#define B_RED		(1 << 1)
#define B_YELLOW	(1 << 2)
#define B_BLUE		(1 << 3)
#define B_ORANGE	(1 << 4)

#define FRET_MASK	(0x1f)

#define B_STRUMUP	(1 << 8)
#define B_STRUMDOWN	(1 << 5)

#define STRUM_MASK	(B_STRUMUP | B_STRUMDOWN)

#define HIT_WINDOW_FORWARD 150
#define HIT_WINDOW_REVERSE 80

extern int resolution;
extern int time_changes;
extern int timechange_beat[];
extern int tempo[];
extern int timechange_ms[];
extern int notes[];
extern int beats[];

typedef struct chart_list_entry {
	struct chart_list_entry* next;
	int time_ms;
	int frets;

} chart_entry_t;

struct note_struct {
	union {
		struct {
			int note : 7;
			int ypos : 9;
			const int blank : 16;
		} __attribute__ ((packed));
		alt_32 data;
	};
};

chart_entry_t* load_chart();

long long get_notetime_ms(int beats);

#endif /* NOTE_H_ */
