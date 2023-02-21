#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <amqp.h>
#include <amqp_tcp_socket.h>
#include <json.h>

#include <sys/time.h>
#include <signal.h>

#include "utils.h"
#include "rec_packet.h"

// #define TIME_ANALYSYS

amqp_connection_state_t conn;
struct timeval timeout;

struct json_object *jobj = NULL;
amqp_rpc_reply_t res;
amqp_envelope_t envelope;
char const *routingkey = "fft";
int amqp_init(char const *hostname, int port, char const *routingkey) {
    int status;

    jobj = json_object_new_object();

    amqp_socket_t *socket = NULL;
    conn = amqp_new_connection();
    

    socket = amqp_tcp_socket_new(conn);
    if (!socket)
    {
        // fprintf(stderr, "creating TCP socket\n");
        die("creating TCP socket");
    }

    status = amqp_socket_open(socket, hostname, port);
    if (status)
    {
        // fprintf(stderr, "opening TCP socket\n");
        die("opening TCP socket");
    }

    die_on_amqp_error(amqp_login(conn, "/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN,
                                 "guest", "guest"),
                      "Logging in");
    amqp_channel_open(conn, 1);
    die_on_amqp_error(amqp_get_rpc_reply(conn), "Opening channel");

    {
        amqp_queue_declare_ok_t *r = amqp_queue_declare(
            conn, 1, amqp_cstring_bytes(routingkey), 1, 0, 0, 0, amqp_empty_table);
        die_on_amqp_error(amqp_get_rpc_reply(conn), "Declaring queue");
        
    }

    amqp_table_entry_t q_arg_n_elms2[1];
    q_arg_n_elms2[0] = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-stream-offset"), .value = {.kind = AMQP_FIELD_KIND_UTF8, .value = {.bytes = amqp_cstring_bytes("last")}}};
    amqp_table_t  q_arg_table2 = {.num_entries=1, .entries=q_arg_n_elms2};

    amqp_basic_qos(conn, 1, 0, 1, 0);
    amqp_basic_consume(conn, 1, amqp_cstring_bytes(routingkey), amqp_empty_bytes,
                       0, 0, 0, q_arg_table2);
    die_on_amqp_error(amqp_get_rpc_reply(conn), "Consuming");

    timeout.tv_sec = 0;
    timeout.tv_usec = 100;
    return 0;
}
 
int amqp_get_data(fft_size_t * p_data_arr, int *p_sw_val, int *p_key_val)
{
    // envelope.redelivered = 0;

    amqp_maybe_release_buffers(conn);

    res = amqp_consume_message(conn, &envelope, &timeout, 0);

    if (AMQP_RESPONSE_NORMAL == res.reply_type)
    {
        // printf("Delivery %u, exchange %.*s routingkey %.*s\n",
        //        (unsigned)envelope.delivery_tag, (int)envelope.exchange.len,
        //        (char *)envelope.exchange.bytes, (int)envelope.routing_key.len,
        //        (char *)envelope.routing_key.bytes);
        // printf("%s\n", (char *)envelope.message.body.bytes);
        // printf("%d\n", envelope.message.body.len);

        // positively acknowledge all deliveries up to
        // this delivery tag
        amqp_basic_ack(conn, 1, envelope.delivery_tag, 0);
        // struct json_object *fft_values = json_object_get_array(jobj, "fft_values");

        if (envelope.message.properties._flags & AMQP_BASIC_CONTENT_TYPE_FLAG)
        {
            jobj = json_tokener_parse((char *)envelope.message.body.bytes);
            struct json_object *fft_values = json_object_object_get(jobj, "fft_values");
            struct json_object *sw_values = json_object_object_get(jobj, "sw_values");
            struct json_object *key_values = json_object_object_get(jobj, "key_values");

            if (fft_values != NULL)
            {
                for (int i = 0; i < MAX_PACKET_LEN; i++)
                    p_data_arr[i] = json_object_get_int64(json_object_array_get_idx(fft_values, i));
            }

            if (sw_values != NULL)
            {
                *p_sw_val = json_object_get_int(sw_values);
            }
            
            if (key_values != NULL)
            {
                *p_key_val = json_object_get_int(key_values);
            }
            json_object_put(jobj);
            // printf("Content-type: %.*s\n",
            //         (int)envelope.message.properties.content_type.len,
            //         (char *)envelope.message.properties.content_type.bytes);
        }
        // printf("----\n");

        // amqp_dump(envelope.message.body.bytes, envelope.message.body.len);

        amqp_destroy_envelope(&envelope);
    }


    
    return 0;
}

int amqp_close() 
{
    die_on_amqp_error(amqp_channel_close(conn, 1, AMQP_REPLY_SUCCESS),
                      "Closing channel");
    die_on_amqp_error(amqp_connection_close(conn, AMQP_REPLY_SUCCESS),
                      "Closing connection");
    die_on_error(amqp_destroy_connection(conn), "Ending connection");
    return 0;
}
