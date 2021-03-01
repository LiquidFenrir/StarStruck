include starlet.mk

# enabled usbgecko support
CFLAGS += -DCAN_HAZ_USBGECKO
# disables debug spew over usbgecko
#CFLAGS += -DNDEBUG
# enables LFCR linefeeds for usbgecko output, useful for some terminal apps
#CFLAGS += -DGECKO_LFCR
# uses the 'safe' version of the usbgecko receive and send functions
#CFLAGS += -DGECKO_SAFE

ASFLAGS += -D_LANGUAGE_ASSEMBLY
CFLAGS += -DCAN_HAZ_IRQ -DCAN_HAZ_IPC
LDSCRIPT = mini.ld
LIBS = -lgcc

ELFLOADER = elfloader/elfloader.bin
MAKEBIN = $(CURDIR)/makebin.py

TARGET = armboot-sym.elf
TARGET_STRIPPED = armboot.elf
TARGET_BIN = armboot.bin
OBJS = start.o main.o ipc.o vsprintf.o string.o gecko.o memory.o memory_asm.o \
	utils_asm.o utils.o ff.o diskio.o sdhc.o powerpc_elf.o powerpc.o panic.o \
	irq.o irq_asm.o exception.o exception_asm.o seeprom.o crypto.o nand.o \
	boot2.o ldhack.o sdmmc.o es.o

include common.mk

all: $(TARGET_BIN) loader

main.o: main.c git_version.h

$(TARGET_STRIPPED): $(TARGET)
	@echo  "STRIP	$@"
	@$(STRIP) $< -o $@

$(TARGET_BIN): $(TARGET_STRIPPED) $(ELFLOADER)
	@echo  "MAKEBIN	$@"
	@$(MAKEBIN) $(ELFLOADER) $< $@

run: 
	@make --no-print-directory -C ppcloader -f Makefile run
loader:
	@echo making ppcloader...
	@make --no-print-directory -C ppcloader -f Makefile
	
upload: $(TARGET_BIN)
	@$(WIIDEV)/bin/bootmii -a $<

git_version.h: describesimple.sh
	@echo "  GITVER    $@"
	@echo 'const char git_version[] = "'`./describesimple.sh`'";' > git_version.h

clean: myclean

$(ELFLOADER):
	@$(MAKE) -C elfloader

myclean:
	-rm -f $(TARGET) $(TARGET_STRIPPED) $(TARGET_BIN) git_version.h
	@$(MAKE) -C elfloader clean
	@make --no-print-directory -C ppcloader -f Makefile clean

