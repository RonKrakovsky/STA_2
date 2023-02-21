#ifndef DATA_PROVIDER_H
#define DATA_PROVIDER_H

#include <QtCore/QTimer>
#include "fft.h"

class DataProvider: public QObject
{
    Q_OBJECT

public:
    DataProvider();

private slots:
    void handleTimer();

signals:
    void valueChanged(fft_t *arr);

private:
    QTimer timer;
};

#endif /* DATA_PROVIDER_H */