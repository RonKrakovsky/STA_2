#ifndef WINDOW_H
#define WINDOW_H

#include <QWidget>
#include <QtCharts/QChartView>
#include "fft.h"
// #include "values.h"
// #include "chart.h"
QT_CHARTS_USE_NAMESPACE

// class Values;
class Chart;

class Window : public QWidget
{
    Q_OBJECT

public slots:
    void handleValueChanged(fft_t *arr);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();

public:
    Window();

private:
    // Values *values;
    QChartView *chartView;
    Chart *chart;
};

#endif