#include "chart.h"
#include <QtCharts/QAbstractAxis>
#include <QtCharts/QSplineSeries>
#include <QtCharts/QValueAxis>

Chart::Chart(QGraphicsItem *parent, Qt::WindowFlags wFlags):
    QChart(QChart::ChartTypeCartesian, parent, wFlags),
    m_series(0),
    m_axisX(new QValueAxis()),
    m_axisY(new QValueAxis())
{
    const float div_factor = (float(CLK_FREQ)/(FFT_SIZE)); // fft frequency resolution

    // create the constant values for the x axis
    for (int i = 0; i < MAX_PACKET_LEN; i++)
        axisX_v[i] = ((i*div_factor)/1000000)+30; // /100000 - to convert to MHz | +30 to add 30 MHz offset to start frequency
        
    // m_series = new QSplineSeries(this); // smoother graph - slower rendering time
    m_series = new QLineSeries();
    QPen pen(Qt::red);  // color of the graph's line
    pen.setWidth(1);    // width of the graph's line
    m_series->setPen(pen);

    addSeries(m_series);

    // start the graph from the bottom left corner
    addAxis(m_axisX,Qt::AlignBottom);
    addAxis(m_axisY,Qt::AlignLeft);
    
    const int y_max = 0;   // Set max power value to 0 dBm
    const int y_min = -130; // Set min power value to -130 dBm
    m_axisY->setRange(y_min, y_max);
    m_axisY->setTickCount(((y_max-y_min)/10)+1); // number of grid lines in y axis needed to get a line every 10dBm

    m_axisX->setRange(30, 66);  // frequency 30 to 66 MHz
    m_axisX->setTickCount(7);   // set x axis grid line every 6 MHz
    
    m_axisX->setMinorGridLineVisible(true);  
    m_axisX->setMinorTickCount(2);  // set minor grid line every 2 MHz

    // font for the numbers ??
    QFont f = m_axisX->labelsFont();
    f.setPointSize(8);
    m_axisX->setLabelsFont(f);
    m_axisY->setLabelsFont(f);

    // chart margin
    setMargins(QMargins(0,0,0,0));

    // removed title to increase chart size
    // setTitle("Powerrrrr (°C)");

    // ??
    legend()->hide();
}

void Chart::handleValueChanged(fft_t *arr)
{
    // remove series so it won't render the frame while changing data and cause a performance loss
    this->removeSeries(m_series);

    m_series->clear(); // clears old data
    for (int i = 0; i < MAX_PACKET_LEN; i++)
    {
        // qDebug()  << "Frequency: " << (axisX_v[i]) << "Value: " << (float(arr[i])/4194304) << "Val: " << (float(arr[i])/4194304)-157 << "Index: " << i;
        m_series->append(axisX_v[i], (float(arr[i])/4194304)-169); // data is ufix32_24 so /2^24 to convert to actual values | -169 for calibration offset
    }
    // add series again to render it
    this->addSeries(m_series);

    // reattach axis scale mark values
    m_series->attachAxis(m_axisX);
    m_series->attachAxis(m_axisY);
}