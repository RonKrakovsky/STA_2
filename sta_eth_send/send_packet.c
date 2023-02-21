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

#include "fft.h"
// #define TIME_ANALYSYS
uint8_t handlingSend = 0;
uint8_t handlingReceive = 0;

uint8_t handleReceive = 0;
uint8_t handleSend = 0;

char const *getFFTJSON(struct json_object *jobj);

void timer_callback(int signum)
{
    // struct timeval now;
    // gettimeofday(&now, NULL);
    // printf("int rec s %d \t\n", (now.tv_sec * 1000) + (now.tv_usec / 1000));
    // printf("int rec\n");
    // if (handlingReceive == 0)
    //     handleReceive = 1;
    if (handlingSend == 0)
        handleSend = 1;
}

char const *getFFTJSON(struct json_object *jobj)
{ // get fft values arr, convert it to json object and insert its string value to messagebody
    fft_size_t arr[MAX_PACKET_LEN];
    int ret = getFft(arr, NULL);

    char const *messagebody;

    json_object_object_del(jobj, "fft_values");
    json_object_object_del(jobj, "sw_values");
    json_object_object_del(jobj, "key_values");

    json_object *jarr = json_object_new_array();

    for (int i = 0; i < MAX_PACKET_LEN; i++)
        json_object_array_add(jarr, json_object_new_uint64(arr[i]));

    json_object_object_add(jobj, "fft_values", jarr);
    json_object *j_sw_val = json_object_new_int(get_sw_state());
    json_object_object_add(jobj, "sw_values", j_sw_val);
    json_object *j_key_val = json_object_new_int(get_key_state());
    json_object_object_add(jobj, "key_values", j_key_val);

    // printf("jobj from str:\n---\n%s\n---\n", json_object_to_json_string_ext(jobj, JSON_C_TO_STRING_PLAIN));

    messagebody = json_object_to_json_string_ext(jobj, JSON_C_TO_STRING_PLAIN);

    return messagebody;
    // printf("messagebody from str:\n---\n%s\n---\n", messagebody);
}

int main(int argc, char const *const *argv)
{
    char const *hostname;
    int port, status;
    char const *routingkey;
    char const *exchange = "";
    char const *messagebody;

    amqp_socket_t *socket = NULL;
    amqp_connection_state_t conn;
    struct json_object *jobj = NULL;

    printf("Usage: send_packet rabbit_server_host port queue_name\n");

    if (argc > 1)
        hostname = argv[1];
    else
        hostname = "192.168.1.103";

    if (argc > 2)
        port = atoi(argv[2]);
    else
        port = 5672;

    if (argc > 3)
        routingkey = argv[3];
    else
        routingkey = "fft";
    
    initFft();

    jobj = json_object_new_object();

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

    // "x-queue-type", "stream";
    amqp_table_entry_t q_arg_n_elms[2];
    
    // q_arg_n_elms[0] = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-queue-type"), .value = {.kind = AMQP_FIELD_KIND_UTF8, .value = {.bytes = amqp_cstring_bytes("stream")}}};
    q_arg_n_elms[0] = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-max-age"), .value = {.kind = AMQP_FIELD_KIND_UTF8, .value = {.bytes = amqp_cstring_bytes("1s")}}};
    q_arg_n_elms[1] = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-max-length-bytes"), .value = {.kind = AMQP_FIELD_KIND_I64, .value = {.i64 = 40000}}};
    
    // q_arg_n_elms[2] = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-max-length"), .value = {.kind = AMQP_FIELD_KIND_I64, .value = {.i32 = 5 }}};
    // amqp_table_entry_t  *q_arg_n_elms = (amqp_table_entry_t *)malloc(sizeof(amqp_table_entry_t));
    // *q_arg_n_elms = (amqp_table_entry_t) {.key = amqp_cstring_bytes("x-max-length"),
    //             .value = {.kind = AMQP_FIELD_KIND_I64, .value = {.i32 = 5 }}};
    
    amqp_table_t  q_arg_table = {.num_entries=2, .entries=q_arg_n_elms};

    amqp_queue_declare_ok_t *r = amqp_queue_declare(
        conn, 1, amqp_cstring_bytes(routingkey), 0, 0, 0, 0, q_arg_table);
    die_on_amqp_error(amqp_get_rpc_reply(conn), "Declaring queue");
        
        // queuename = amqp_bytes_malloc_dup(r->queue);
        // if (queuename.bytes == NULL) {
        //     fprintf(stderr, "Out of memory while copying queue name");
        //     return 1;
        // }
    

    struct itimerval new_timer;
    struct itimerval old_timer;

    new_timer.it_value.tv_sec = 1;
    new_timer.it_value.tv_usec = 0;
    new_timer.it_interval.tv_sec = 0;
    new_timer.it_interval.tv_usec = 40000; // 1e6[usec]/25[Hz]

    setitimer(ITIMER_REAL, &new_timer, &old_timer);
    signal(SIGALRM, timer_callback);
    
    while (1)
    {
        if (handleSend == 1)
        {
            handlingSend = 1;
            
#ifdef TIME_ANALYSYS
            struct timeval now;
            gettimeofday(&now, NULL);
            printf("s %d \t\n", (now.tv_sec * 1000) + (now.tv_usec / 1000));
#endif

            amqp_basic_properties_t props;
            props._flags = AMQP_BASIC_CONTENT_TYPE_FLAG | AMQP_BASIC_DELIVERY_MODE_FLAG;
            props.content_type = amqp_cstring_bytes("text/plain");
            props.delivery_mode = 2; /* persistent delivery mode */
            // props.delivery_mode = 1;
            // props.expiration = amqp_cstring_bytes("0");

            messagebody = getFFTJSON(jobj);
            die_on_error(amqp_basic_publish(conn, 1, amqp_cstring_bytes(exchange),
                                            amqp_cstring_bytes(routingkey), 0, 0,
                                            &props, amqp_cstring_bytes(messagebody)),
                         "Publishing");

#ifdef TIME_ANALYSYS
            gettimeofday(&now, NULL);
            printf("d %d \n", (now.tv_sec * 1000) + (now.tv_usec / 1000));
#endif
            handleSend = 0;
            handlingSend = 0;
        }
    }

    json_object_put(jobj);

    die_on_amqp_error(amqp_channel_close(conn, 1, AMQP_REPLY_SUCCESS),
                      "Closing channel");
    die_on_amqp_error(amqp_connection_close(conn, AMQP_REPLY_SUCCESS),
                      "Closing connection");
    die_on_error(amqp_destroy_connection(conn), "Ending connection");
    return 0;
}
