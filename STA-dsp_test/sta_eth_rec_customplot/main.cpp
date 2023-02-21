#include <QApplication>
#include "window.h"
#include "chart.h"
#include "data-provider.h"

int main(int argc, char* argv[])
{
    char const *hostname;
    int port;
    char const *routingkey;

    printf("Usage: sta_eth_rec rabbit_server_host port queue_name\n");

    if (argc > 1)
        hostname = argv[1];
    else
        hostname = "192.168.1.102";

    if (argc > 2)
        port = atoi(argv[2]);
    else
        port = 5672;

    if (argc > 3)
        routingkey = argv[3];
    else
        routingkey = "fft";

    QApplication app(argc, argv);
    DataProvider dp(hostname, port, routingkey);
    Window window;

    QObject::connect(&dp, &DataProvider::valueChanged,
		     &window, &Window::handleValueChanged);

    QObject::connect(&dp, &DataProvider::colorChanged,
		     &window, &Window::handleColorChanged);

    QObject::connect(&dp, &DataProvider::key0Pressed,
		     &window, &Window::handleKey0Pressed);
    
    QObject::connect(&dp, &DataProvider::key1Pressed,
		     &window, &Window::handleKey1Pressed);

    QObject::connect(&dp, &DataProvider::key2Pressed,
		     &window, &Window::handleKey2Pressed);

    QObject::connect(&dp, &DataProvider::key3Pressed,
		     &window, &Window::handleKey3Pressed);

    QObject::connect(&dp, &DataProvider::rotateLeft,
		     &window, &Window::handleRotateLeft);

    QObject::connect(&dp, &DataProvider::rotateRight,
		     &window, &Window::handleRotateRight);

    window.setFixedSize(1024, 768);
    // window.setFixedSize(640, 480);
    
    // window.setStyleSheet("padding: 1px;");
    // window.setStyleSheet("background-color: white;");
    // window.setStyleSheet("background-color: #464646;");
    // chart->setBackgroundBrush(QBrush(QColor(70, 70, 70, 255)));
    
    window.show();
    return app.exec();
}