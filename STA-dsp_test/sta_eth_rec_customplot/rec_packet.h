#ifndef REC_PACKET_H
#define REC_PACKET_H

#include "fft.h"

int amqp_init(char const *hostname, int port, char const *routingkey);
int amqp_close();
int amqp_get_data(fft_size_t * p_data_arr, int *p_sw_val, int *p_key_val);

#endif /* REC_PACKET_H */