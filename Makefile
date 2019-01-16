#
MCU=atmega328p
AVRDUDE_FLAGS=-c usbtiny

#DEFINES=-DBOARD2 -DADF4113


# configure binaries.
CC=avr-gcc
CXX=avr-g++
AR=avr-ar
AS=avr-as
AVRDUDE=avrdude

# select C dialect
#CFLAGS = -std=c11
#CXXFLAGS = -std=c++11
CFLAGS = -std=gnu11 ${DEFINES}
CXXFLAGS = -std=gnu++11 ${DEFINES}

# generate .d dependency files
CXXFLAGS += -MMD
CFLAGS += -MMD

# debug, warning
CFLAGS += -g -W -Wall -Werror
#CFLAGS += -g -W -Wall -Werror -Wno-error=unused-parameter -Wno-error=incompatible-pointer-types
#CFLAGS += -g -W
CXXFLAGS += -g -W -Wall -Werror
#CXXFLAGS += -g -W -Wall -Werror -Wno-error=unused-parameter

# optimizations
#CFLAGS += -Os
#CXXFLAGS += -Os
CFLAGS += -O3
CXXFLAGS += -O3

# gcc g++
TARGET_ARCH += -mmcu=${MCU}
TARGET_ARCH += -mcall-prologues
ifdef F_CPU
TARGET_ARCH += -DF_CPU=${F_CPU}
endif

# C,C++ listings from assembler.
CFLAGS += -Wa,-a=$(@:.o=.lst)
CXXFLAGS += -Wa,-a=$(@:.o=.lst)

# as
TARGET_MACH += -mmcu=${MCU}
ASFLAGS += -a=$(@:.o=.lst)

%.hex: %.elf
	avr-objdump -h -S $< >$(basename $@)-elf.lst
	avr-objcopy -O ihex -R .eeprom $< $@
	avr-objdump -t $< | sort | uniq >$(basename $@).sym

%.burn: %.hex
	avrdude $(AVRDUDE_FLAGS) -p $(MCU) -Uflash:w:$<:i

%.elf: %.o
	$(LINK.cc) -Wl,-Map,$(basename $@).map  $^ $(LOADLIBES) $(LDLIBS) -o $@

main.elf : main.o lcd.o  settings.o  smeter.o  spectrum.o  vfo.o

clean:
	-rm *.o *.elf

# reset fuses to factory default
fuses:
	avrdude $(AVRDUDE_FLAGS) -p atmega328p -U lfuse:w:0xFF:m
	avrdude $(AVRDUDE_FLAGS) -p atmega328p -U lfuse:w:0x62:m
	avrdude $(AVRDUDE_FLAGS) -p atmega328p -U hfuse:w:0xD9:m
	avrdude $(AVRDUDE_FLAGS) -p atmega328p -U efuse:w:0xFF:m
