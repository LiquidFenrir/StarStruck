include ../../starlet.mk

CFLAGS += -Os -Wall -I.
ASFLAGS += -D_LANGUAGE_ASSEMBLY
LDFLAGS += -nostartfiles -nodefaultlibs -Tmini.ld
LIBS = -lgcc

ELFLOADER = ../elfloader/elfloader.bin
MAKEBIN = python ../makebin.py

TARGET = armboot.elf
TARGET_BIN = armboot.bin
OBJS = start.o main.o ipc.o vsprintf.o string.o gecko.o memory.o memory_asm.o \
	utils_asm.o utils.o ff.o diskio.o sdhc.o powerpc_elf.o powerpc.o panic.o \
	irq.o irq_asm.o exception.o exception_asm.o seeprom.o crypto.o nand.o \
	boot2.o ldhack.o

include ../../common.mk

all: $(TARGET_BIN)

$(TARGET_BIN): $(TARGET) $(ELFLOADER) 
	@echo  "MAKEBIN	$@"
	@$(MAKEBIN) $(ELFLOADER) $< $@

clean: myclean

myclean:
	-rm -f mini.bin

