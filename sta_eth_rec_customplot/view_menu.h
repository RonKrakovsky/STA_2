#ifndef VIEW_MENU_H
#define VIEW_MENU_H

#include <QWidget>
#include <QtWidgets>

class ViewMenu : public QWidget
{
    Q_OBJECT

// public slots:
//     void handleValueChanged(fft_size_t *arr, int sw_val);

// private slots:
    // void chartButtonClicked();
    // void valuesButtonClicked();
signals:
    void colorChanged(uint8_t color);

public:
    bool ret_main;
    bool hide_menus;
    ViewMenu();
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

    QPushButton *button0;
    QPushButton *button1;
    QPushButton *button2;
    QPushButton *button3;

    bool dark_mode;
};

#endif