#ifndef MAIN_MENU_H
#define MAIN_MENU_H

#include <QWidget>
#include <QtWidgets>

class MainMenu : public QWidget
{
    Q_OBJECT

// public slots:
//     void handleValueChanged(fft_size_t *arr, int sw_val);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();

public:
    MainMenu();

private:
    QVBoxLayout *buttons;
};

#endif