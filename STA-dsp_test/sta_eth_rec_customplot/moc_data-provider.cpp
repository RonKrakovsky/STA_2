/****************************************************************************
** Meta object code from reading C++ file 'data-provider.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "data-provider.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'data-provider.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_DataProvider_t {
    QByteArrayData data[15];
    char stringdata0[151];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_DataProvider_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_DataProvider_t qt_meta_stringdata_DataProvider = {
    {
QT_MOC_LITERAL(0, 0, 12), // "DataProvider"
QT_MOC_LITERAL(1, 13, 12), // "valueChanged"
QT_MOC_LITERAL(2, 26, 0), // ""
QT_MOC_LITERAL(3, 27, 9), // "uint32_t*"
QT_MOC_LITERAL(4, 37, 3), // "arr"
QT_MOC_LITERAL(5, 41, 12), // "colorChanged"
QT_MOC_LITERAL(6, 54, 7), // "uint8_t"
QT_MOC_LITERAL(7, 62, 5), // "color"
QT_MOC_LITERAL(8, 68, 11), // "key0Pressed"
QT_MOC_LITERAL(9, 80, 11), // "key1Pressed"
QT_MOC_LITERAL(10, 92, 11), // "key2Pressed"
QT_MOC_LITERAL(11, 104, 11), // "key3Pressed"
QT_MOC_LITERAL(12, 116, 10), // "rotateLeft"
QT_MOC_LITERAL(13, 127, 11), // "rotateRight"
QT_MOC_LITERAL(14, 139, 11) // "handleTimer"

    },
    "DataProvider\0valueChanged\0\0uint32_t*\0"
    "arr\0colorChanged\0uint8_t\0color\0"
    "key0Pressed\0key1Pressed\0key2Pressed\0"
    "key3Pressed\0rotateLeft\0rotateRight\0"
    "handleTimer"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DataProvider[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       8,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   59,    2, 0x06 /* Public */,
       5,    1,   62,    2, 0x06 /* Public */,
       8,    0,   65,    2, 0x06 /* Public */,
       9,    0,   66,    2, 0x06 /* Public */,
      10,    0,   67,    2, 0x06 /* Public */,
      11,    0,   68,    2, 0x06 /* Public */,
      12,    0,   69,    2, 0x06 /* Public */,
      13,    0,   70,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      14,    0,   71,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3,    4,
    QMetaType::Void, 0x80000000 | 6,    7,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,

       0        // eod
};

void DataProvider::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<DataProvider *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->valueChanged((*reinterpret_cast< uint32_t*(*)>(_a[1]))); break;
        case 1: _t->colorChanged((*reinterpret_cast< uint8_t(*)>(_a[1]))); break;
        case 2: _t->key0Pressed(); break;
        case 3: _t->key1Pressed(); break;
        case 4: _t->key2Pressed(); break;
        case 5: _t->key3Pressed(); break;
        case 6: _t->rotateLeft(); break;
        case 7: _t->rotateRight(); break;
        case 8: _t->handleTimer(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (DataProvider::*)(uint32_t * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::valueChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)(uint8_t );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::colorChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::key0Pressed)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::key1Pressed)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::key2Pressed)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::key3Pressed)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::rotateLeft)) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (DataProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataProvider::rotateRight)) {
                *result = 7;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject DataProvider::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_DataProvider.data,
    qt_meta_data_DataProvider,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *DataProvider::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DataProvider::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_DataProvider.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int DataProvider::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void DataProvider::valueChanged(uint32_t * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void DataProvider::colorChanged(uint8_t _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void DataProvider::key0Pressed()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void DataProvider::key1Pressed()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void DataProvider::key2Pressed()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void DataProvider::key3Pressed()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void DataProvider::rotateLeft()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void DataProvider::rotateRight()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
