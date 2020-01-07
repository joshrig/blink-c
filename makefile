# -*- makefile -*-
CC          = arm-none-eabi-gcc
LD          = arm-none-eabi-ld
AS          = arm-none-eabi-as
OBJCOPY     = arm-none-eabi-objcopy
OBJDUMP     = arm-none-eabi-objdump
SIZE        = arm-none-eabi-size

TARGET_ARCH = -mcpu=cortex-m4 -mthumb
CPPFLAGS    =
CFLAGS      = -g -O0
LDFLAGS     = -Tflash.ld

SRCS       := $(wildcard *.c)
OBJS        = $(SRCS:%.c=%.o)
DEPS        = $(SRCS:%.c=%.d)

TARGET      = blink
OUT_ELF     = $(TARGET).elf
OUT_BIN     = $(TARGET).bin
OUT_INFO    = $(TARGET).lss



.PHONY: all
all: $(OUT_ELF) $(OUT_BIN) $(OUT_INFO)


$(OUT_ELF): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

$(OUT_BIN): $(OUT_ELF)
	$(OBJCOPY) -O binary $^ $@

$(OUT_INFO): $(OUT_ELF)
	$(OBJDUMP) -Sh $^ > $@
	$(SIZE) $^

.PHONY: clean
clean:
	-rm -f $(OBJS) $(DEPS) $(TARGET) $(OUT_ELF) $(OUT_BIN) $(OUT_INFO) nul *.d.*



.PHONY: check-syntax
check-syntax:
	$(CC) $(CPPFLAGS) $(CFLAGS) -o nul -S $(CHK_SOURCES)


# standard commands for making a .d file
#
%.d: %.c
	@echo making dependency for $<
	@set -e; \
	rm -f %@; \
	$(CC) -MM $(CFLAGS) $(CPPFLAGS) $< > $@.$$$$; \
	sed 's/\($*\)\.o[ :]*/\1.o $@ : /g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# only include the dependency files (and thus restart make)
# if we're not running the clean or check-syntax goal
#
ifeq (,$(filter clean,$(MAKECMDGOALS))$(filter check-syntax,$(MAKECMDGOALS)))
 -include $(DEPS)
endif

