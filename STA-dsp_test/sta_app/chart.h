#ifndef CHART_H
#define CHART_H

#include <QtCharts/QChart>
#include "fft.h"

QT_CHARTS_BEGIN_NAMESPACE
// class QSplineSeries;
class QLineSeries;
class QValueAxis;
QT_CHARTS_END_NAMESPACE

QT_CHARTS_USE_NAMESPACE

class Chart: public QChart
{
    Q_OBJECT

public:
    Chart(QGraphicsItem *parent = 0, Qt::WindowFlags wFlags = Qt::Widget);

public slots:
    void handleValueChanged(fft_t *arr);

private:
    // QSplineSeries *m_series; // smoother graph - slower rendering time
    QLineSeries *m_series;
    // QStringList m_titles;
    QValueAxis *m_axisX;
    QValueAxis *m_axisY;
    float axisX_v[MAX_PACKET_LEN];
};

#endif /* CHART_H */