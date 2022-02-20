#ifndef _TIMER_H
#define _TIMER_H 

#include "../drivers/screen.h"
#include "../drivers/low_level.h"
#include "../util/int_to_ascii.h"
#include "../util/types.h"
#include "isr.h"

#define PIT_FREQ 1193180

void init_timer(uint32_t frequency);

#endif

