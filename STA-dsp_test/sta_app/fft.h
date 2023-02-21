#ifndef FFT_H
#define FFT_H

#include <QDebug>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>


#define HPS_FPGA_BRIDGE_LW_BASE 0xff200000
#define HPS_FPGA_BRIDGE_LW_SPAN 0x00200000
#define HPS_FPGA_BRIDGE_LW_MASK (HPS_FPGA_BRIDGE_LW_SPAN - 1)

#define HPS_OCR_BASE 0xFFFF0000
#define HPS_OCR_SPAN 0x00010000
#define HPS_OCR_MASK (HPS_OCR_SPAN - 1)

#define PACKET_WRITER_BASE 0x8000
#define PACKET_WRITER_SPAN 0x40
#define PACKET_WRITER_MASK (PACKET_WRITER_SPAN - 1)

#define MAX_PACKET_LEN 3932 // len of packet got from fpga's three filter component
#define FFT_SIZE 16384      // length of the fft transform
#define CLK_FREQ 150000000  // sampling rate

#define fft_t uint32_t      // size of data from fpga

int getFft(fft_t *arr_ptr);
int initFft();

#endif /* FFT_H */
