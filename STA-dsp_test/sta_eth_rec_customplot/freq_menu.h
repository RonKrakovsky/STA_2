#ifndef FREQ_MENU_H
#define FREQ_MENU_H

#include <QWidget>
#include <QtWidgets>

class FreqMenu : public QWidget
{
    Q_OBJECT

// public slots:
//     void handleValueChanged(fft_size_t *arr, int sw_val);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();
signals:
    void spanChanged(float fstart, float fstop);

public:
    bool ret_main;
    FreqMenu();
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

    QPushButton *fstart_fc_button;
    QPushButton *fstop_bw_button;
    QPushButton *mode_button;
    QPushButton *ret_button;

    bool fstart_fc_pressed;
    bool fstop_bw_pressed;

    float fstart;
    float fstop;
    float fc;
    float bw;

    float temp_fstart;
    float temp_fstop;
    float temp_fc;
    float temp_bw;
};

#endif