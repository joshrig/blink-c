#include <inttypes.h>


#define STACK_TOP 0x20010000

extern uint32_t _DATA_ROM_START;
extern uint32_t _DATA_RAM_START;
extern uint32_t _DATA_RAM_END;
extern uint32_t _BSS_START;
extern uint32_t _BSS_END;


void startup(void);
int main(void);


void *vector_table[] __attribute__((section("vectors"))) = {
    (void *)STACK_TOP,
    (void *)startup
};


void startup(void)
{
    uint32_t *ram_start = &_DATA_RAM_START;
    uint32_t *ram_end   = &_DATA_RAM_END;
    uint32_t *rom_start = &_DATA_ROM_START;
    uint32_t *bss_start = &_BSS_START;
    uint32_t *bss_end   = &_BSS_END;
    
    while (ram_start != ram_end)
        *ram_start++ = *rom_start++;

    while (bss_start != bss_end)
        *bss_start++ = 0x0;

    main();

    while(1);
}


#define PORTC_DIR *((uint32_t *)0x41008100)
#define PORTC_OUT *((uint32_t *)0x41008110)


int main(void)
{
    uint8_t state = 0;


    PORTC_DIR = 1 << 18;

    while (1)
    {
        PORTC_OUT = state << 18;

        state = state ? 0 : 1;

        for (uint32_t j = 0; j < 1000000; j++);
    }
    
    
    return 0;
}
