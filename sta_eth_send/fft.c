#include "fft.h"
#include <string.h>

volatile void *virtual_hps_ocr_base;
volatile void *virtual_hps_fpga_lw_bridge_base;
volatile uint32_t* packet_writer_ptr;
volatile uint32_t* fpga_sw_ptr;
volatile uint32_t* fpga_key_ptr;

int initFft() {
    int fd;
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        printf("ERROR: could not open \"/dev/mem\"...");
        return (1);
    }

    virtual_hps_ocr_base = mmap(NULL, HPS_OCR_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS_OCR_BASE);
    virtual_hps_fpga_lw_bridge_base = mmap(NULL, HPS_FPGA_BRIDGE_LW_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS_FPGA_BRIDGE_LW_BASE);
    packet_writer_ptr = (uint32_t *)((uint8_t *)virtual_hps_fpga_lw_bridge_base + PACKET_WRITER_BASE);
    fpga_sw_ptr = (uint32_t *)((uint8_t *)virtual_hps_fpga_lw_bridge_base + FPGA_SW_BASE);
    fpga_key_ptr = (uint32_t *)((uint8_t *)virtual_hps_fpga_lw_bridge_base + FPGA_KEY_BASE);

    if (virtual_hps_ocr_base == MAP_FAILED)
    {
        printf("ERROR: mmap() failed...");
        close(fd);
        return (1);
    }

    if (virtual_hps_fpga_lw_bridge_base == MAP_FAILED)
    {
        printf("ERROR: mmap() failed...");
        close(fd);
        return (1);
    }
    printf("end fft init");
    return 0;
}

int getFft(fft_size_t *arr_ptr, size_t *p_fft_len) {
    // On Chip Memory in HPS
    fft_size_t *hps_ocr_ptr = (fft_size_t *)virtual_hps_ocr_base;
    
    memset(hps_ocr_ptr, 0, sizeof(fft_size_t)*MAX_PACKET_LEN);

    packet_writer_ptr[0] = 2; // clear
    packet_writer_ptr[1] = (uint32_t)HPS_OCR_BASE; // set base address to ocr base
    packet_writer_ptr[0] = 1;                      // go flag

    while((packet_writer_ptr[0] & 2) == 0); // wait for done flag
    
    packet_writer_ptr[0] = 2; // clear

    memcpy(arr_ptr, hps_ocr_ptr, sizeof(fft_size_t)*MAX_PACKET_LEN);
    return 0;

}

int get_sw_state() {
    return (int)(((uint32_t)(*fpga_sw_ptr)) & FPGA_SW_MASK);
}

int get_key_state() {
    return (int)(((uint32_t)(*fpga_key_ptr)) & FPGA_KEY_MASK);
}