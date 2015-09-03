SDCC = sdcc
STM8FLASH = stm8flash

CHIP = STM8S003
CHIP_LCASE  = $(shell echo $(CHIP) | tr '[:upper:]' '[:lower:]')

STD_LIB_DIR = ./libsrc/stm8_stdlib
STD_LIB_INC_DIR = ./libsrc/stm8_stdlib/inc
STD_LIB_FILE = stm8s_stdlib.a

CFLAGS = -lstm8 -mstm8 -L$(STD_LIB_DIR) -l$(STD_LIB_FILE) -I$(STD_LIB_INC_DIR) -D$(CHIP) -DUSE_STDPERIPH_DRIVER

MAIN_SOURCE = tracker 
SOURCES = 

all: clean build

build: $(MAIN_SOURCE:=.ihx)

$(MAIN_SOURCE:=.ihx): $(STD_LIB_DIR)/$(STD_LIB_FILE) $(MAIN_SOURCE:=.rel) $(SOURCES:=.rel)
	$(SDCC) $(CFLAGS) --out-fmt-ihx $(MAIN_SOURCE:=.rel) $(SOURCES:=.rel)

clean:
	rm -f *.ihx *.lk *.lst *.map *.rel *.rst *.sym *.asm *.cdb

flash: $(MAIN_SOURCE:=.ihx)
	$(STM8FLASH) -cstlink -p$(CHIP_LCASE) -w $(MAIN_SOURCE:=.ihx)

%.rel: %.c
	$(SDCC) -c $(CFLAGS) $<

stdlib: $(STD_LIB_DIR)/$(STD_LIB_FILE)

$(STD_LIB_DIR)/$(STD_LIB_FILE):
	make -C $(STD_LIB_DIR)

.PHONY: all build clean flash stdlib