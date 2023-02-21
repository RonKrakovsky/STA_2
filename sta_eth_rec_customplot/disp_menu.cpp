#include "disp_menu.h"
#include "chart.h"
#include "data-provider.h"



const QString buttons_style = QString(
    "font: 22px;"
    "color: #00ffff;"
    "background-color: #505050;"
    "border-style: outset;"
    "border-color: #646464;"
    "border-width: 1px;"
);

const QString checked_button = QString(
    "font: 22px;"
    "color: #00ffff;"
    "background-color: #505050;"
    "border-style: outset;"
    "border-color: white;"
    "border-width: 2px;"
);

DispMenu::DispMenu()
{
    buttons = new QVBoxLayout;
    buttons->setMargin(0);

    this->max_hold_pressed = false;
    this->stop_pressed = false;
    this->window_pressed = false;
    this->ret_main = false;

    const QSize buttons_size = QSize(100, 150);

    max_hold_button = new QPushButton("Max hold");
    stop_chart_button = new QPushButton("STOP");
    window_change_button = new QPushButton("Window:\n");
    window_change_button->setText(QString("Window:\nChange"));
    ret_button = new QPushButton("RET");
    
    max_hold_button->setStyleSheet(buttons_style);
    stop_chart_button->setStyleSheet(buttons_style);
    window_change_button->setStyleSheet(buttons_style);
    ret_button->setStyleSheet(buttons_style);

    max_hold_button->setFixedSize(buttons_size);
    stop_chart_button->setFixedSize(buttons_size);
    window_change_button->setFixedSize(buttons_size);
    ret_button->setFixedSize(buttons_size);

    // QObject::connect(chart_button, &QPushButton::clicked,
    //                 this, &Window::chartButtonClicked);
    // QObject::connect(values_button, &QPushButton::clicked,
    //                 this, &Window::valuesButtonClicked);


    buttons->addWidget(max_hold_button);
    buttons->addWidget(stop_chart_button);
    buttons->addWidget(window_change_button);
    buttons->addWidget(ret_button);


    // values->hide();
    // chartView->show();

    this->setLayout(buttons);
}


void DispMenu::key0Pressed()
{   
    this->max_hold_pressed = !this->max_hold_pressed;
    if (this->max_hold_pressed == false)
    {
        this->max_hold_button->setStyleSheet(buttons_style);
        emit holdmax_change();
    }
    else
    {
        this->max_hold_button->setStyleSheet(checked_button);
        emit holdmax_change();
    }
}

void DispMenu::key1Pressed()
{
    fft_size_t arr[MAX_PACKET_LEN];
    int sw_val;
    int key_val;

    this->stop_pressed = !this->stop_pressed;
    if (this->stop_pressed == false)
    {
        this->stop_chart_button->setStyleSheet(buttons_style);
        emit hold_change();
    }
    else
    {
        this->stop_chart_button->setStyleSheet(checked_button);
        // stop all chart
        amqp_get_data(arr, &sw_val, &key_val);
        emit valueChanged(arr);
        emit hold_change();
    }

}

void DispMenu::key2Pressed()
{

}

void DispMenu::key3Pressed()
{
    
}
