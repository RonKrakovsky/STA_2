#include <QtCore/QFile>
#include "data-provider.h"

DataProvider::DataProvider(char const *hostname, int port, char const *routingkey)
{
    amqp_init(hostname, port, routingkey);
    QObject::connect(&timer, &QTimer::timeout,
		     this, &DataProvider::handleTimer); // create timer and set DataProvider::handleTimer() function as its callback
    timer.setInterval(17); // set timer to provide data from fpga in 60Hz (1000msec/60Hz)
    timer.start();
}

void DataProvider::handleTimer()
{
    fft_size_t arr[MAX_PACKET_LEN];
    int sw_val;
    int key_val;
    if (amqp_get_data(arr, &sw_val, &key_val) == 0)
    {
        // printf("%d\t %d\n", key_val, this->key_val);
        // if (!(key_val & 1) && (this->key_val & 1)) {
        //     emit key0Pressed();
        // }
        // if (!(key_val & 2) && (this->key_val & 2)) {
        //     emit key1Pressed();
        // }
        // if (!(key_val & 4) && (this->key_val & 4)) {
        //     emit key2Pressed();
        // }
        // if (!(key_val & 8) && (this->key_val & 8)) {
        //     emit key3Pressed();
        // }
        
        if ((sw_val & 2) && !(this->sw_val & 2)) {
            emit key0Pressed();
        }
        if ((sw_val & 4) && !(this->sw_val & 4)) {
            emit key1Pressed();
        }
        if ((sw_val & 8) && !(this->sw_val & 8)) {
            emit key2Pressed();
        }
        if ((sw_val & 16) && !(this->sw_val & 16)) {
            emit key3Pressed();
        }

        if (!(key_val & 4) && (this->key_val & 4)) {
            emit rotateRight();
        }
        if (!(key_val & 8) && (this->key_val & 8)) {
            emit rotateLeft();
        }

        this->key_val = key_val;
        this->sw_val = sw_val;
        emit valueChanged(arr);
    }
}