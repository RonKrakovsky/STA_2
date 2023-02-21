#include "freq_menu.h"
#include "chart.h"

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

FreqMenu::FreqMenu()
{
    buttons = new QVBoxLayout;
    buttons->setMargin(0);

    this->fstart = 30;
    this->fstop = 66;
    this->bw = fstop-fstart;
    this->fc = fstart+(bw/2);

    this->mode = false;
    this->fstart_fc_pressed = false;
    this->fstop_bw_pressed = false;
    this->ret_main = false;
    

    const QSize buttons_size = QSize(100, 150);

    
    fstart_fc_button = new QPushButton("Start:\n");
    fstart_fc_button->setText(QString("Start:\n%1\nMHz").arg(((int)((this->fstart)*1000))/1000.0));
    fstop_bw_button = new QPushButton("Stop:\n");
    fstop_bw_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->fstop)*1000))/1000.0));
    mode_button = new QPushButton("Mode");
    // fstop_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->fstop)*1000))/1000.0));
    ret_button = new QPushButton("RET");
    
    fstart_fc_button->setStyleSheet(buttons_style);
    fstop_bw_button->setStyleSheet(buttons_style);
    mode_button->setStyleSheet(buttons_style);
    ret_button->setStyleSheet(buttons_style);

    fstart_fc_button->setFixedSize(buttons_size);
    fstop_bw_button->setFixedSize(buttons_size);
    mode_button->setFixedSize(buttons_size);
    ret_button->setFixedSize(buttons_size);

    // QObject::connect(chart_button, &QPushButton::clicked,
    //                 this, &Window::chartButtonClicked);
    // QObject::connect(values_button, &QPushButton::clicked,
    //                 this, &Window::valuesButtonClicked);


    buttons->addWidget(fstart_fc_button);
    buttons->addWidget(fstop_bw_button);
    buttons->addWidget(mode_button);
    buttons->addWidget(ret_button);


    // values->hide();
    // chartView->show();

    this->setLayout(buttons);
}

void FreqMenu::enterSelectMode()
{
    this->temp_fstart = this->fstart;
    this->temp_fstop = this->fstop;
    this->temp_fc = this->fc;
    this->temp_bw = this->bw;
}

void FreqMenu::exitSelectMode()
{
    if (this->mode)
    {
        this->fc = this->temp_fc;
        this->bw = this->temp_bw;
        this->fstart = this->fc - this->bw/2;
        this->fstop = this->fc + this->bw/2;
    }
    
    else
    {
        this->fstart = this->temp_fstart;
        this->fstop = this->temp_fstop;
    }

    if (this->fstart < 30)
    {
        this->fstart = 30;
    }
    else if (this->fstart > 66)
    {
        this->fstart = 66;
    }

    if (this->fstop < 30)
    {
        this->fstop = 30;
    }
    else if (this->fstop > 66)
    {
        this->fstop = 66;
    }

    this->bw = this->fstop-this->fstart;
    this->fc = (this->bw/2) + this->fstart;
    
    if (this->mode)
    {
        fstart_fc_button->setText(QString("Center:\n%1\nMHz").arg(((int)((this->fc)*1000))/1000.0));
        fstop_bw_button->setText(QString("BW:\n%1\nMHz").arg(((int)((this->bw)*1000))/1000.0));
    }
    else
    {
        fstart_fc_button->setText(QString("Start:\n%1\nMHz").arg(((int)((this->fstart)*1000))/1000.0));
        fstop_bw_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->fstop)*1000))/1000.0));
    }
    emit spanChanged(this->fstart, this->fstop);
}

void FreqMenu::key0Pressed()
{
    if (!this->fstop_bw_pressed)
    {
        this->fstart_fc_pressed = !this->fstart_fc_pressed;
        if (this->fstart_fc_pressed == false)
        {
            this->exitSelectMode();
            this->fstart_fc_button->setStyleSheet(buttons_style);
        }
        else
        {
            this->fstart_fc_button->setStyleSheet(checked_button);
            this->enterSelectMode();
        }
    }
}

void FreqMenu::key1Pressed()
{
    if (!this->fstart_fc_pressed)
    {
        this->fstop_bw_pressed = !this->fstop_bw_pressed;
        if (this->fstop_bw_pressed == false)
        {
            this->exitSelectMode();
            this->fstop_bw_button->setStyleSheet(buttons_style);
        }
        else
        {
            this->fstop_bw_button->setStyleSheet(checked_button);
            this->enterSelectMode();
        }
    }
}

void FreqMenu::key2Pressed()
{
    if (!this->fstart_fc_pressed && !this->fstop_bw_pressed)
    {
        this->mode = !this->mode;

        if (this->mode)
        {
            fstart_fc_button->setText(QString("Center:\n%1\nMHz").arg(((int)((this->fc)*1000))/1000.0));
            fstop_bw_button->setText(QString("BW:\n%1\nMHz").arg(((int)((this->bw)*1000))/1000.0));
        }
        else
        {
            fstart_fc_button->setText(QString("Start:\n%1\nMHz").arg(((int)((this->fstart)*1000))/1000.0));
            fstop_bw_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->fstop)*1000))/1000.0));
        }
    }
}

void FreqMenu::key3Pressed()
{
    if (!this->fstart_fc_pressed && !this->fstop_bw_pressed)
    {
        this->ret_main = 1;
    }
}

#define INC_VAL 1

void FreqMenu::rotateLeft()
{
    if (this->mode)
    {
        if (this->fstart_fc_pressed)
        {
            this->temp_fc -= INC_VAL;
            fstart_fc_button->setText(QString("Center:\n%1\nMHz").arg(((int)((this->temp_fc)*1000))/1000.0));
        }
        
        if (this->fstop_bw_pressed)
        {
            this->temp_bw -= INC_VAL;
            fstop_bw_button->setText(QString("BW:\n%1\nMHz").arg(((int)((this->temp_bw)*1000))/1000.0));
        }
    }
    else
    {
        if (this->fstart_fc_pressed)
        {
            this->temp_fstart -= INC_VAL;
            fstart_fc_button->setText(QString("Start:\n%1\nMHz").arg(((int)((this->temp_fstart)*1000))/1000.0));
        }
        
        if (this->fstop_bw_pressed)
        {
            this->temp_fstop -= INC_VAL;
            fstop_bw_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->temp_fstop)*1000))/1000.0));
        }
    }
}

void FreqMenu::rotateRight()
{
    if (this->mode)
    {
        if (this->fstart_fc_pressed)
        {
            this->temp_fc += INC_VAL;
            fstart_fc_button->setText(QString("Center:\n%1\nMHz").arg(((int)((this->temp_fc)*1000))/1000.0));
        }
        
        if (this->fstop_bw_pressed)
        {
            this->temp_bw += INC_VAL;
            fstop_bw_button->setText(QString("BW:\n%1\nMHz").arg(((int)((this->temp_bw)*1000))/1000.0));
        }
    }
    else
    {
        if (this->fstart_fc_pressed)
        {
            this->temp_fstart += INC_VAL;
            fstart_fc_button->setText(QString("Start:\n%1\nMHz").arg(((int)((this->temp_fstart)*1000))/1000.0));
        }
        
        if (this->fstop_bw_pressed)
        {
            this->temp_fstop += INC_VAL;
            fstop_bw_button->setText(QString("Stop:\n%1\nMHz").arg(((int)((this->temp_fstop)*1000))/1000.0));
        }
    }
}