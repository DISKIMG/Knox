#include <stddef.h>
#include "arch/x86_64/limine.h"

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[] = LIMINE_BASE_REVISION(6);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
    .revision = 0
};

void kmain() {
    if (framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1) {
        for (;;);
    }

    struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];

    uint32_t *fb_ptr = (uint32_t *)fb->address;

    uint32_t stride = fb->pitch / 4;

    for (uint64_t y = 50; y < 150; y++) {     
        for (uint64_t x = 50; x < 150; x++) { 
            fb_ptr[y * stride + x] = 0xFFFFFF;
        }
    }

    for (;;);
}