#ifndef DISP_MENU_H
#define DISP_MENU_H

#include <QWidget>
#include <QtWidgets>
#include "fft.h"


class DispMenu : public QWidget
{
    Q_OBJECT

// public slots:
//     void handleValueChanged(fft_size_t *arr, int sw_val);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();
signals:
    void spanChanged(float fstart, float fstop);
    void hold_change();
    void holdmax_change();
    void valueChanged(fft_size_t *arr);

public:
    bool ret_main;
    DispMenu();
    void key0Pressed();
    void key1Pressed();
    void key2Pressed();
    void key3Pressed();
    void rotateLeft();
    void rotateRight();
    
    
private:
    void enterSelectMode();
    void exitSelectMode();
    QVBoxLayout *buttons;
    bool mode;
    bool window_pressed;
    bool stop_pressed;
    bool max_hold_pressed;

    QPushButton *max_hold_button;
    QPushButton *stop_chart_button;
    QPushButton *window_change_button;
    QPushButton *ret_button;

    bool stop_chart_pressed;

    // float fstart;
    // float fstop;
    // float fc;
    // float bw;

    // float temp_fstart;
    // float temp_fstop;
    // float temp_fc;
    // float temp_bw;
};

#endif