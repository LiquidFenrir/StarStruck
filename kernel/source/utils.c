/*
	mini - a Free Software replacement for the Nintendo/BroadOn IOS.
	random utilities

Copyright (C) 2008, 2009	Hector Martin "marcan" <marcan@marcansoft.com>

# This code is licensed to you under the terms of the GNU GPL, version 2;
# see file COPYING or http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
*/

#include <stdarg.h>
#include <types.h>
#include <vsprintf.h>
#include <ios/gecko.h>
#include <ios/processor.h>

#include "core/gpio.h"
#include "core/hollywood.h"
#include "utils.h"

//no idea why this has less issues when forced as arm...
__attribute__((target("arm")))
void udelay(u32 d)
{
	// should be good to max .2% error
	// IOS does this through a method that checks the mode/clk speed
	u32 ticks = d * 19 / 10;

	if(ticks < 2)
		ticks = 2;

	u32 now = read32(HW_TIMER);
	u32 then = now  + ticks;

	if(then < now) {
		while(read32(HW_TIMER) >= now);
		now = read32(HW_TIMER);
	}

	while(now < then) {
		now = read32(HW_TIMER);
	}
}

void panic(u8 v)
{
	while(1) {
		debug_output(v);
		set32(HW_GPIO1BOUT, GP_SLOTLED);
		udelay(500000);
		debug_output(0);
		clear32(HW_GPIO1BOUT, GP_SLOTLED);
		udelay(500000);
	}
}

