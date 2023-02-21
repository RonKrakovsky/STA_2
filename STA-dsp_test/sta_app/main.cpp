#include <QApplication>
#include "window.h"
#include "data-provider.h"

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    DataProvider dp;
    Window window;

    QObject::connect(&dp, &DataProvider::valueChanged,
		     &window, &Window::handleValueChanged);

    // window.setFixedSize(1024, 768);
    window.setFixedSize(640, 480);
    window.setStyleSheet("background-color: white;");
    window.show();
    return app.exec();
}