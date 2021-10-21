ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_rules

CFLAGS = -mbig-endian -mcpu=arm926ej-s
CFLAGS += -fomit-frame-pointer -ffunction-sections
CFLAGS += -Wall -Wextra -Os -pipe -g
ASFLAGS =
LDFLAGS = -mbig-endian -n -nostartfiles -nodefaultlibs -Wl,-gc-sections
COREDIR = ./core

ifeq ($(LD),)
LD 		= $(PREFIX)ld
endif


%.elf:
	$(SILENTMSG) linking $(notdir $@)
	$(SILENTCMD)$(CC) $(CFLAGS) $(LDFLAGS) $(OFILES) -o $@ $(foreach dir,$(LIBDIRS), -L$(dir)) $(LIBS)
	$(SILENTCMD)$(NM) -CSn $@ > $(notdir $*.lst)
	
%.a:
	$(SILENTMSG) archiving $(notdir $@)
	$(SILENTCMD)rm -f $@
	$(SILENTCMD)$(AR) -rc $@ $(OFILES)
	$(SILENTCMD)$(RANLIB) $@