#include <QtCore/QFile>
#include "data-provider.h"

DataProvider::DataProvider()
{
    initFft();  // initalize fft's memory mapping
    QObject::connect(&timer, &QTimer::timeout,
		     this, &DataProvider::handleTimer); // create timer and set DataProvider::handleTimer() function as its callback
    timer.setInterval(17); // set timer to provide data from fpga in 60Hz (1000msec/60Hz)
    timer.start(); 
}

void DataProvider::handleTimer()
{
    fft_t arr[MAX_PACKET_LEN];
    if (getFft(arr) == 0)
        emit valueChanged(arr);
}