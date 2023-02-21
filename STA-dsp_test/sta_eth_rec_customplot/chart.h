#ifndef CHART_H
#define CHART_H

#include "fft.h"
#include "qcustomplot.h"

class Chart: public QCustomPlot
{
    Q_OBJECT

public:
    Chart(QWidget *parent = 0);

public slots:
    void handleValueChanged(fft_size_t *arr);
    void handleColorChanged(uint8_t color);
    void handleSpanChanged(float fstart, float fstop);

private:

    // QCPAxis *m_axisX;
    // QCPAxis *m_axisY;
    QVector<double> *x;
    QVector<double> *y;

    float fstart, fstop;
    int fstart_idx, fstop_idx;
    float axisX_v[MAX_PACKET_LEN];

};

#endif /* CHART_H */