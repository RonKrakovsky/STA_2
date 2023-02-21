#include <QtWidgets>

#include "window.h"
#include "chart.h"
Window::Window()
{
    // values = new Values;
    chart = new Chart;
    QVBoxLayout *layout = new QVBoxLayout;

    // remove spacing & margin to increace graph size
    layout->setSpacing(0);
    layout->setMargin(0);
    // QHBoxLayout *buttons = new QHBoxLayout;

    // QPushButton *values_button = new QPushButton("Values");
    // QPushButton *chart_button = new QPushButton("Chart");
    // QObject::connect(chart_button, &QPushButton::clicked,
    //                 this, &Window::chartButtonClicked);
    // QObject::connect(values_button, &QPushButton::clicked,
    //                 this, &Window::valuesButtonClicked);

    // buttons->addWidget(values_button);
    // buttons->addWidget(chart_button);

    chart->setBackgroundBrush(QBrush(QColor("white")));
    chartView = new QChartView(chart);
    chartView->setRenderHint(QPainter::Antialiasing);
    // chartView.chart().setBackgroundBrush(QBrush(QColor("salmon")));
    // layout->addWidget(values);
    layout->addWidget(chartView);
    // layout->addLayout(buttons);

    setLayout(layout);

    // values->hide();
    // chartView->show();

    setWindowTitle(tr("Sensors"));
}

void Window::handleValueChanged(fft_t *arr)
{
    // values->handleValueChanged(arr);
    chart->handleValueChanged(arr);
}

// void Window::chartButtonClicked()
// {
//     values->hide();
//     chartView->show();
// }

// void Window::valuesButtonClicked()
// {
//     values->show();
//     chartView->hide();
// }