#include "chart.h"
#include <QtCharts/QAbstractAxis>
#include <QtCharts/QSplineSeries>
#include <QtCharts/QValueAxis>
#include <QDebug> 

Chart::Chart(QGraphicsItem *parent, Qt::WindowFlags wFlags):
    QChart(QChart::ChartTypeCartesian, parent, wFlags),
    m_series(0),
    m_axisX(new QValueAxis()),
    m_axisY(new QValueAxis())
{
    // create the constant values for the x axis
    const float div_factor = (float(CLK_FREQ)/(FFT_SIZE));
    for (int i = 0; i < MAX_PACKET_LEN; i++)
        axisX_v[i] = ((i*div_factor)/1000000)+30;
    
    this->fstart = 30;
    this->fstop = 66;

    this->fstart_idx = 0;
    this->fstop_idx = MAX_PACKET_LEN;

    // m_series = new QSplineSeries(this);
    m_series = new QLineSeries();
    QPen pen(Qt::red);
    pen.setColor(QColor(0, 255, 255, 255));
    pen.setWidth(1);
    m_series->setPen(pen);

    addSeries(m_series);

    addAxis(m_axisX,Qt::AlignBottom);
    addAxis(m_axisY,Qt::AlignLeft);
    
    const int y_max = 0;   // 0 dBm
    const int y_min = -130; // -130 dBm

    
    // grid_pen.setDashPattern()
    m_axisY->setRange(y_min, y_max);
    m_axisY->setTickCount(((y_max-y_min)/10)+1); // number of grid lines needed to get a line every 10dBm
    m_axisY->setGridLineColor(QColor("black"));
    // m_axisY->tick(QBrush(QColor("black")));

    m_axisX->setRange(this->fstart, this->fstop);  // frequency 30 to 66 MHz
    m_axisX->setTickCount(7);   // set grid line every 6 MHz

    m_axisX->setMinorGridLineVisible(true);  
    m_axisX->setMinorTickCount(2);  // set minor grid line every 2 MHz

    // font for the numbers ??
    QFont f = m_axisX->labelsFont();
    f.setPointSize(14);
    
    m_axisX->setLabelsFont(f);
    m_axisY->setLabelsFont(f);
    m_axisX->setLabelsColor(QColor("white"));
    m_axisY->setLabelsColor(QColor("white"));
    

    // chart margin
    setMargins(QMargins(0,0,0,0));

    // removed title to increase chart size
    // setTitle("Powerrrrr (°C)");
    

    // ??
    legend()->hide();
}

void Chart::handleColorChanged(uint8_t color)
{
    qDebug() << "darkmode: " << color;
    if (color == 1)
    {
        QPen pen(Qt::red);
        m_series->setPen(pen);
        m_axisX->setLabelsColor(QColor("black"));
        m_axisY->setLabelsColor(QColor("black"));
        m_axisY->setGridLineColor(QColor("black"));
        m_axisX->setGridLineColor(QColor(100, 100, 100, 255));
        m_axisX->setMinorGridLineColor(QColor(100, 100, 100, 255));
    }
    else
    {
        QPen pen(Qt::red);
        pen.setColor(QColor(0, 255, 255, 255));
        pen.setWidth(1);
        m_series->setPen(pen);
        m_axisX->setLabelsColor(QColor("white"));
        m_axisY->setLabelsColor(QColor("white"));
        m_axisY->setGridLineColor(QColor("white"));
        m_axisX->setGridLineColor(QColor(100, 100, 100, 255));
        m_axisX->setMinorGridLineColor(QColor(100, 100, 100, 255));
    }
}

void Chart::handleValueChanged(fft_size_t *arr)
{
    this->removeSeries(m_series);
    // m_series->hide();
    m_series->clear();

    for (int i = this->fstart_idx; i < this->fstop_idx; i++)
    {
        //qDebug()  << "Frequency: " << (axisX_v[i]) << "Value: " << (float(arr[i])/4194304) << "Val: " << (float(arr[i])/4194304)-157 << "Index: " << i;
        // if ((float(arr[i])/4194304) > -90) 
            // printf("Freq: %f\t\t Val: %f\n", axisX_v[i], (float(arr[i])/4194304))
            // qDebug()  << "Frequency: " << (axisX_v[i]) << "Value: " << (float(arr[i])/4194304);
        m_series->append(axisX_v[i], (float(arr[i])/4194304)-167.5);
    }
    this->addSeries(m_series);
    m_series->attachAxis(m_axisX);
    m_series->attachAxis(m_axisY);
    m_series->show();
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
    m_axisX->setRange(fstart, fstop);
    
}