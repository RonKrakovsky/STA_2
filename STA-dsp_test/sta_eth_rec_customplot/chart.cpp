#include "chart.h"
#include <QDebug> 


Chart::Chart(QWidget *parent):
    QCustomPlot(parent)
{
    // create the constant values for the x axis
    x = new QVector<double>(MAX_PACKET_LEN);
    y = new QVector<double>(MAX_PACKET_LEN);
    
    const float div_factor = (float(CLK_FREQ)/(FFT_SIZE));
    for (int i = 0; i < MAX_PACKET_LEN; i++)
        (*x)[i] = ((i*div_factor)/1000000)+30;
    
    this->fstart = 30;
    this->fstop = 66;

    this->fstart_idx = 0;
    this->fstop_idx = MAX_PACKET_LEN;

    this->addGraph();

    QPen pen(Qt::red);
    pen.setColor(QColor(0, 255, 255, 255));
    pen.setWidth(1);
    this->graph(0)->setPen(pen);
    
    
    const int y_max = 0;   // 0 dBm
    const int y_min = -130; // -130 dBm

    // grid_pen.setDashPattern()
    this->yAxis->setRange(y_min, y_max); // m_axisY->setRange(y_min, y_max);
    this->yAxis->ticker()->setTickCount(((y_max-y_min)/10)+1); // number of grid lines needed to get a line every 10dBm
    // m_axisY->setGridLineColor(QColor("black"));
    // m_axisY->tick(QBrush(QColor("black")));

    this->xAxis->setRange(this->fstart, this->fstop); // m_axisX->setRange(this->fstart, this->fstop);  // frequency 30 to 66 MHz
    this->xAxis->ticker()->setTickCount(7); // set grid line every 6 MHz
    // this->xAxis->ticker()->setTickStepStrategy(QCPAxisTicker::TickStepStrategy())

    this->xAxis->setSubTicks(true);
    // this->xAxis->setSubT;
    // this->xAxis->ticker()->set
    this->xAxis->grid()->setSubGridVisible(true);
    // this->xAxis->grid()->
    // m_axisX->setMinorGridLineVisible(true);  
    // m_axisX->setMinorTickCount(2);  // set minor grid line every 2 MHz

    // font for the numbers ??
    QFont f = QFont();
    f.setPointSize(14);
    
    this->xAxis->setTickLabelFont(f);
    this->yAxis->setTickLabelFont(f);
    this->xAxis->setTickLabelColor("white");
    this->yAxis->setTickLabelColor("white");
    this->xAxis->grid()->setPen(QPen("white"));
}

void Chart::handleValueChanged(fft_size_t *arr)
{
    for (int i = this->fstart_idx; i < this->fstop_idx; i++)
    {
        (*y)[i] = (float(arr[i])/4194304)-167.5;
    }
    this->graph(0)->setData(*x, *y);
    this->replot();
}

void Chart::handleSpanChanged(float fstart, float fstop)
{
    const float div_factor = (float(CLK_FREQ)/(FFT_SIZE));
    // qDebug() << "fstart: " << this->fstart << "\t" << " fstop: " << this->fstop << "\t" << " fstart_idx: " << this->fstart_idx << "\t" << "fstop_idx: " << this->fstop_idx << "\n";
    if (fstart < 30)
    {
        fstart = 30;
        this->fstart_idx = 0;
    }
    else if (fstart > 66)
    {
        fstart = 66;
        this->fstart_idx = MAX_PACKET_LEN;
    }
    else 
    {
        this->fstart_idx = (int)((fstart-30)/(div_factor/1e6));
    }

    if (fstop < 30)
    {
        fstop = 30;
        this->fstop_idx = 0;
    }
    else if (fstop > 66)
    {
        fstop = 66;
        this->fstop_idx = MAX_PACKET_LEN-1;
    }
    else 
    {
        this->fstop_idx = (int)((fstop-30)/(div_factor/1e6));
    }
    
    // qDebug() << "fstart: " << this->fstart << "\t" << " fstop: " << this->fstop << "\t" << " fstart_idx: " << this->fstart_idx << "\t" << "fstop_idx: " << this->fstop_idx << "\n";
    this->fstart = fstart;
    this->fstop = fstop;
    this->xAxis->setRange(this->fstart, this->fstop);
}

void Chart::handleColorChanged(uint8_t color)
{
    // qDebug() << "darkmode: " << color;
    QPen pen = this->graph(0)->pen();
    if (color == 1)
    {
        pen.setColor(QColor("red"));
        this->xAxis->setTickLabelColor("black");
        this->yAxis->setTickLabelColor("black");
        this->yAxis->grid()->setPen(QPen("black"));
        // this->xAxis->grid()->setPen(QPen(QColor(100, 100, 100, 255)));
        // m_axisX->setMinorGridLineColor(QColor(100, 100, 100, 255));
        // this->xAxis->grid();
    }
    else
    {
        pen.setColor(QColor(0, 255, 255, 255));
        this->xAxis->setTickLabelColor("white");
        this->yAxis->setTickLabelColor("white");
        this->yAxis->grid()->setPen(QPen("white"));
        // this->xAxis->grid()->setPen(QPen(QColor(100, 100, 100, 255)));
        // m_axisX->setMinorGridLineColor(QColor(100, 100, 100, 255));
        // this->xAxis->grid();
    }
    this->graph(0)->setPen(pen);
}