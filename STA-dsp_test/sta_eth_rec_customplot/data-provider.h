#ifndef DATA_PROVIDER_H
#define DATA_PROVIDER_H

#include <QtCore/QTimer>
#include "fft.h"
#include "rec_packet.h"

class DataProvider: public QObject
{
    Q_OBJECT

public:
    DataProvider(char const *hostname, int port, char const *routingkey);

private slots:
    void handleTimer();

signals:
    void valueChanged(fft_size_t *arr);
    void colorChanged(uint8_t color);
    void key0Pressed();
    void key1Pressed();
    void key2Pressed();
    void key3Pressed();
    void rotateLeft();
    void rotateRight();

private:
    QTimer timer;
    int sw_val;
    int key_val;
};

#endif /* DATA_PROVIDER_H */