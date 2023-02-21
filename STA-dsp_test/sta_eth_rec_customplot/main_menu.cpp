#include "main_menu.h"

MainMenu::MainMenu()
{
    buttons = new QVBoxLayout;
    buttons->setMargin(0);

    const QString buttons_style = QString(
        "font: 22px;"
        "color: #00ffff;"
        "background-color: #505050;"
        "border-style: outset;"
        "border-color: #646464;"
        "border-width: 1px;"
    );

    const QSize buttons_size = QSize(100, 150);

    QPushButton *freq_button = new QPushButton("Freq");
    QPushButton *meas_button = new QPushButton("Meas");
    QPushButton *display_button = new QPushButton("Disp");
    QPushButton *view_button = new QPushButton("View");
    
    freq_button->setStyleSheet(buttons_style);
    meas_button->setStyleSheet(buttons_style);
    display_button->setStyleSheet(buttons_style);
    view_button->setStyleSheet(buttons_style);

    freq_button->setFixedSize(buttons_size);
    meas_button->setFixedSize(buttons_size);
    display_button->setFixedSize(buttons_size);
    view_button->setFixedSize(buttons_size);

    // QObject::connect(chart_button, &QPushButton::clicked,
    //                 this, &Window::chartButtonClicked);
    // QObject::connect(values_button, &QPushButton::clicked,
    //                 this, &Window::valuesButtonClicked);

    buttons->addWidget(freq_button);
    buttons->addWidget(meas_button);
    buttons->addWidget(display_button);
    buttons->addWidget(view_button);

    // values->hide();
    // chartView->show();

    this->setLayout(buttons);
}