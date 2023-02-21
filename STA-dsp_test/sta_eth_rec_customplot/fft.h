#ifndef FFT_H
#define FFT_H

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
// #include <stdlib.h>
#include <stdint.h>


#define HPS_FPGA_BRIDGE_LW_BASE 0xff200000
#define HPS_FPGA_BRIDGE_LW_SPAN 0x00200000
#define HPS_FPGA_BRIDGE_LW_MASK (HPS_FPGA_BRIDGE_LW_SPAN - 1)

#define HPS_OCR_BASE 0xFFFF0000
#define HPS_OCR_SPAN 0x00010000
#define HPS_OCR_MASK (HPS_OCR_SPAN - 1)

#define PACKET_WRITER_BASE 0x8000
#define PACKET_WRITER_SPAN 0x40
#define PACKET_WRITER_MASK (PACKET_WRITER_SPAN - 1)

#define FPGA_SW_BASE 0x4000
#define FPGA_SW_SPAN 0x4
#define FPGA_SW_MASK (FPGA_SW_SPAN - 1)

// #define MAX_PACKET_LEN 1024
#define MAX_PACKET_LEN 3932
#define FFT_SIZE 16384
#define CLK_FREQ 150000000

#define fft_size_t uint32_t

int getFft(fft_size_t *arr_ptr, size_t *p_fft_len);
int initFft();

#endif /* FFT_H */
