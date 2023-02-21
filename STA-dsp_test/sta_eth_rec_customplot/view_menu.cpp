#include "view_menu.h"

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

ViewMenu::ViewMenu()
{
    buttons = new QVBoxLayout;
    buttons->setMargin(0);

    this->ret_main = false;
    this->dark_mode = true;

    const QSize buttons_size = QSize(100, 150);

    
    button0 = new QPushButton("Hide\nMenus");
    button1 = new QPushButton("Dark\nMode");
    button2 = new QPushButton("Export");
    button3 = new QPushButton("RET");
    
    button0->setStyleSheet(buttons_style);
    button1->setStyleSheet(buttons_style);
    button2->setStyleSheet(buttons_style);
    button3->setStyleSheet(buttons_style);

    button0->setFixedSize(buttons_size);
    button1->setFixedSize(buttons_size);
    button2->setFixedSize(buttons_size);
    button3->setFixedSize(buttons_size);

    buttons->addWidget(button0);
    buttons->addWidget(button1);
    buttons->addWidget(button2);
    buttons->addWidget(button3);

    this->setLayout(buttons);
}

void ViewMenu::enterSelectMode()
{
}

void ViewMenu::exitSelectMode()
{
    
}

void ViewMenu::key0Pressed()
{
    this->hide_menus = !this->hide_menus;
}

void ViewMenu::key1Pressed()
{
    this->dark_mode = !this->dark_mode;
    emit colorChanged(!this->dark_mode);
}

void ViewMenu::key2Pressed()
{

}

void ViewMenu::key3Pressed()
{
    this->ret_main = 1;
}

void ViewMenu::rotateLeft()
{

}

void ViewMenu::rotateRight()
{
 
}