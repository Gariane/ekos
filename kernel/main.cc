#include <stdint.h>

extern "C" void kmain() {

    volatile uint16_t *const VGA_BUFFER = ( uint16_t * )0xB8000;

    const char *message = "Hello kernel world!";

    int i = 0;
    while ( *message != '\0' ) {
        VGA_BUFFER[++i] = ( static_cast<uint16_t>((*(message++))) & 0x00FF ) | 0x0F00;
    }

}