#include "fft.h"

volatile void *virtual_hps_ocr_base;
volatile void *virtual_hps_fpga_lw_bridge_base;
volatile uint32_t* packet_writer_ptr;

int initFft() {
    int fd;
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        qDebug() << "ERROR: could not open \"/dev/mem\"...";
        return (1);
    }

    // map hps ocr physical address to virtual address
    virtual_hps_ocr_base = mmap(NULL, HPS_OCR_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS_OCR_BASE);

    // map hps2fpga lw bridge physical address to virtual address
    virtual_hps_fpga_lw_bridge_base = mmap(NULL, HPS_FPGA_BRIDGE_LW_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HPS_FPGA_BRIDGE_LW_BASE);

    if (virtual_hps_ocr_base == MAP_FAILED)
    {
        qDebug() << "ERROR: mmap() failed...";
        close(fd);
        return (1);
    }

    if (virtual_hps_fpga_lw_bridge_base == MAP_FAILED)
    {
        qDebug() << "ERROR: mmap() failed...";
        close(fd);
        return (1);
    }

    // set packet writer pointer to correct address offset in lw bridge
    // first convert to uint8_t pointer because PACKET_WRITER_BASE offset is in bytes
    // then convert to uint32_t pointer because the data size is 4 bytes
    packet_writer_ptr = (uint32_t *)((uint8_t *)virtual_hps_fpga_lw_bridge_base + PACKET_WRITER_BASE);

    return 0;
}

int getFft(fft_t *arr_ptr) {
    // On Chip Memory in HPS
    fft_t *hps_ocr_ptr = (fft_t *)virtual_hps_ocr_base;
    
    memset(hps_ocr_ptr, 0, sizeof(fft_t)*MAX_PACKET_LEN);   // clear hps ocr memory

    packet_writer_ptr[0] = 2;                       // clear
    packet_writer_ptr[1] = (uint32_t)HPS_OCR_BASE;  // set base address to ocr base
    packet_writer_ptr[0] = 1;                       // go flag

    while((packet_writer_ptr[0] & 2) == 0); // wait for done flag
    
    packet_writer_ptr[0] = 2; // clear

    memcpy(arr_ptr, hps_ocr_ptr, sizeof(fft_t)*MAX_PACKET_LEN); // copy hps ocr memory to arr_ptr
    return 0;

}