#include <QtWidgets>
#include <QTime>
#include <Qt>

#include "window.h"
#include "chart.h"


QElapsedTimer m_time;
int m_frameCount;

Window::Window()
{
    // values = new Values;
    chart = new Chart;
    layout = new QHBoxLayout;

    // remove spacing & margin to increace graph size
    layout->setSpacing(0);
    layout->setMargin(0);

    chart->setBackground(QBrush(QColor(70, 70, 70, 255)));
    this->setStyleSheet("background-color: #464646;");

    mainMenu = new MainMenu();
    freqMenu = new FreqMenu();
    viewMenu = new ViewMenu();
    dispMenu = new DispMenu();
    freqMenu->hide();
    viewMenu->hide();
    dispMenu->hide();
    
    layout->addWidget(chart);
    layout->addWidget(mainMenu);
    layout->addWidget(freqMenu);
    layout->addWidget(viewMenu);
    layout->addWidget(dispMenu);
    
    chart->adjustSize();
    chart->setFixedSize(924, 768);
    current_menu = eMAIN_MENU;

    QVBoxLayout *fps_layout;
    fps_layout = new QVBoxLayout;
    fps_layout->setMargin(0);

    const QString fps_style = QString(
        "font: 22px;"
        "color: #ffffff;"
        "background-color: #505050;"
        "border-style: outset;"
        "border-color: #646464;"
        "border-width: 1px;"
        // "selection-color: #00ffff;"
        // "selection-background-color: #464646;"
    );

    fps_label = new QLabel("FPS:\n 0");
    
    fps_label->setStyleSheet(fps_style);
    fps_label->setFixedSize(100, 80);
    mainMenu->layout()->addWidget(fps_label);
    // fps_label->setAlignment(Qt::AlignCenter);
    
    setLayout(layout);

    QObject::connect(freqMenu, &FreqMenu::spanChanged,
		     chart, &Chart::handleSpanChanged);

    QObject::connect(viewMenu, &ViewMenu::colorChanged,
		     chart, &Chart::handleColorChanged);

    QObject::connect(viewMenu, &ViewMenu::colorChanged,
		     this, &Window::handleColorChanged);

    setWindowTitle(tr("Sensors"));
    
    m_time.start();
}

void Window::handleValueChanged(fft_size_t *arr)
{
    if (m_time.elapsed() / 1000 >= 2) {
        m_time.restart();
        m_frameCount = 0;
    } else {
        int fps = (int)(((m_frameCount) / (float(m_time.elapsed()) / 1000.0f))*10);
        fps_label->setText(QString("FPS:\n%1").arg((float)(fps)/10));
        // printf("FPS is %f ms\n", m_time.elapsed() / float(m_frameCount));
        // printf("FPS is %f\n", m_frameCount / (float(m_time.elapsed()) / 1000.0f));
    }
    m_frameCount++;

    // values->handleValueChanged(arr);
    
    chart->handleValueChanged(arr);
}

void Window::handleColorChanged(uint8_t color)
{
    if (color == 1)
    {
        chart->setBackground(QBrush(QColor("white")));
        this->setStyleSheet("background-color: white;");
    }
    else
    {
        chart->setBackground(QBrush(QColor(70, 70, 70, 255)));
        this->setStyleSheet("background-color: #464646;");
    }
}

void Window::handleKey0Pressed()
{
    switch (current_menu)
    {
    case eNO_MENU:
        viewMenu->show();
        chart->setFixedSize(924, 768);
        current_menu = eVIEW_MENU;
        break;
    case eMAIN_MENU:
        mainMenu->hide();
        freqMenu->layout()->addWidget(fps_label);
        freqMenu->show();
        current_menu = eFREQ_MENU;
        break;
    case eFREQ_MENU:
        freqMenu->key0Pressed();
        current_menu = eFREQ_MENU;
        break;
    case eDISP_MENU:
        dispMenu->key0Pressed();
        current_menu = eDISP_MENU;
        break;
    case eVIEW_MENU:
        viewMenu->key0Pressed();
        if (viewMenu->hide_menus == 1)
        {
            viewMenu->hide();
            chart->setFixedSize(1024, 768);
            // mainMenu->show();
        }
        viewMenu->hide_menus = 0;
        current_menu = eNO_MENU;
        break;
    default:
        break;
    }
}

void Window::handleKey1Pressed()
{
    switch (current_menu)
    {
    case eNO_MENU:
        viewMenu->show();
        chart->setFixedSize(924, 768);
        current_menu = eVIEW_MENU;
        break;
    case eMAIN_MENU:
        // mainMenu->hide();
        // freqMenu->layout()->addWidget(fps_label);
        // freqMenu->show();
        // current_menu = eFREQ_MENU;
        break;
    case eFREQ_MENU:
        freqMenu->key1Pressed();
        current_menu = eFREQ_MENU;
        break;
    case eDISP_MENU:
        dispMenu->key1Pressed();
        current_menu = eDISP_MENU;
        break;
    case eVIEW_MENU:
        viewMenu->key1Pressed();
        current_menu = eVIEW_MENU;
        break;
    default:
        break;
    }
}

void Window::handleKey2Pressed()
{
    switch (current_menu)
    {
    case eNO_MENU:
        viewMenu->show();
        chart->setFixedSize(924, 768);
        current_menu = eVIEW_MENU;
        break;
    case eMAIN_MENU:
        mainMenu->hide();
        dispMenu->layout()->addWidget(fps_label);
        dispMenu->show();
        current_menu = eDISP_MENU;
        break;
    case eFREQ_MENU:
        freqMenu->key2Pressed();
        current_menu = eFREQ_MENU;
        break;
    case eVIEW_MENU:
        viewMenu->key2Pressed();
        current_menu = eVIEW_MENU;
        break;
    default:
        break;
    }
}

void Window::handleKey3Pressed()
{
    switch (current_menu)
    {
    case eNO_MENU:
        viewMenu->show();
        chart->setFixedSize(924, 768);
        current_menu = eVIEW_MENU;
        break;
    case eMAIN_MENU:
        mainMenu->hide();
        viewMenu->layout()->addWidget(fps_label);
        viewMenu->show();
        current_menu = eVIEW_MENU;
        break;
    case eFREQ_MENU:
        freqMenu->key3Pressed();
        if (freqMenu->ret_main == 1)
        {
            freqMenu->hide();
            mainMenu->layout()->addWidget(fps_label);
            mainMenu->show();
        }
        freqMenu->ret_main = 0;
        current_menu = eMAIN_MENU;
        break;
    case eDISP_MENU:
        dispMenu->key3Pressed();
        dispMenu->hide();
        mainMenu->layout()->addWidget(fps_label);
        mainMenu->show();
        current_menu = eMAIN_MENU;
        break;
    case eVIEW_MENU:
        viewMenu->key3Pressed();
        if (viewMenu->ret_main == 1)
        {
            viewMenu->hide();
            mainMenu->layout()->addWidget(fps_label);
            mainMenu->show();
        }
        viewMenu->ret_main = 0;
        current_menu = eMAIN_MENU;
    default:
        break;
    }
}

void Window::handleRotateLeft()
{
    switch (current_menu)
    {
    case eMAIN_MENU:
        break;
    case eFREQ_MENU:
        freqMenu->rotateLeft();
        break;
    default:
        break;
    }
}

void Window::handleRotateRight()
{
    switch (current_menu)
    {
    case eMAIN_MENU:
        break;
    case eFREQ_MENU:
        freqMenu->rotateRight();
        break;
    default:
        break;
    }
}
