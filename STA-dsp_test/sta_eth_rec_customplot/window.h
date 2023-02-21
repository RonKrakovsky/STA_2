#ifndef WINDOW_H
#define WINDOW_H

#include <QWidget>
#include <QtWidgets>
#include <QtCharts/QChartView>
#include "fft.h"
#include "main_menu.h"
#include "freq_menu.h"
#include "view_menu.h"
// #include "values.h"
// #include "chart.h"
QT_CHARTS_USE_NAMESPACE

// class Values;
class Chart;

typedef enum {
    eNO_MENU,
    eMAIN_MENU,
    eFREQ_MENU,
    eMEAS_MENU,
    eDISP_MENU,
    eVIEW_MENU
} menu_t;

class Window : public QWidget
{
    Q_OBJECT

public slots:
    void handleValueChanged(fft_size_t *arr);
    void handleColorChanged(uint8_t color);
    void handleKey0Pressed();
    void handleKey1Pressed();
    void handleKey2Pressed();
    void handleKey3Pressed();
    void handleRotateLeft();
    void handleRotateRight();
    // void handleButtonClicked(uint8_t keys);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();

public:
    Window();

private:
    // Values *values;
    QChartView *chartView;
    Chart *chart;
    QHBoxLayout *layout;
    // QVBoxLayout *buttons;
    MainMenu *mainMenu;
    FreqMenu *freqMenu;
    ViewMenu *viewMenu;
    QLabel *fps_label;
    menu_t current_menu;
    // QPushButton *values_button;
    // QPushButton *chart_button;
};

#endif