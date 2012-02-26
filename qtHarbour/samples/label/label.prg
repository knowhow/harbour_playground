
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL app
  LOCAL mainWindow
  LOCAL boxLayout
  LOCAL label
  local btn
  LOCAL n

  app := QApplication():New()

  mainWindow := QWidget():New()

  boxLayout := QVBoxLayout():New()

  boxLayout:addWidget( QLabel():New( "Text label...", mainWindow ) )

  label := QLabel():New( mainWindow )
  boxLayout:addWidget( label )
  label:setNum( 10 )

  label := QLabel():New( mainWindow )
  boxLayout:addWidget( label )
  label:setNum( 3.14 )
  
  n := 1*(10^6)
  label := QLabel():New( mainWindow )
  boxLayout:addWidget( label )
  label:setNum( n )
  ? "n = ", n
  //label:setNum( 1e50 )


  btn := QPushButton():New( mainWindow )
  btn:setText("button 1")
  boxLayout:addWidget( btn)
  ? "scrit_1 ret", script_1(btn, 2, 3.5)
 
  btn := QPushButton():New( mainWindow )
  btn:setText("button 2")
  boxLayout:addWidget( btn)
  //? "scrit_1 ret", script_1(btn, 7, 8)
  
  mainWindow:setLayout( boxLayout )

  
  mainWindow:show()


  app:exec()

RETURN NIL


#pragma BEGINDUMP

#include "qtHarbour_global.h"
//#include "qtharbour.h"
//#include "hbxvm.h"
#include "hbapi.h"
#include <QPushButton>
#include <QWidget>
#include <QScriptEngine>
#include <QScriptEngineDebugger>

#include <QtGui>
//#include <QtScript>

//#include <QUiLoader>

#ifndef QT_NO_SCRIPTTOOLS
 #include <QtScriptTools>
#endif



enum QTHI_FLAG {
    QTHI_NONE,
    QTHI_TRANSFER,
    QTHI_TRANSFERBACK
};


class QTH_ITEM;

typedef QTH_ITEM* PQTH_ITEM;

typedef void CPP_OBJECT;
typedef CPP_OBJECT* PCPP_OBJECT;

PCPP_OBJECT qth_par_QthObject( int param, const char* inheritFrom = NULL );
void        qth_set_param_QthItemFlag( PQTH_ITEM qthItem, QTHI_FLAG qthiFlag );
PQTH_ITEM   qth_par_QthItem( const int iParam );

template <class Q>
Q* qth_parPtr( const int iParam, QTHI_FLAG qthiFlag = QTHI_NONE )
{
    PQTH_ITEM qthItem = qth_par_QthItem( iParam );

    if( qthItem )
    {
        qth_set_param_QthItemFlag( qthItem, qthiFlag );
    }
    return (Q*) qth_par_QthObject( iParam );
}

//PQTH_ITEM   qth_itemListGet_PQTH_ITEM( PCPP_OBJECT cppObj );
//PQTH_ITEM   qth_itemListGet_PQTH_ITEM( PHB_ITEM pSelf );

static QScriptValue evaluateFile(QScriptEngine &engine, const QString &fileName)
{
     QFile file(fileName);
     file.open(QIODevice::ReadOnly);
     return engine.evaluate(file.readAll(), fileName);
}

struct QtMetaObject : private QObject
{
 public:
     static const QMetaObject *get()
         { return &static_cast<QtMetaObject*>(0)->staticQtMetaObject; }
};

/*
class TetrixUiLoader : public QUiLoader
{
 
  public:
     TetrixUiLoader(QObject *parent = 0)
         : QUiLoader(parent)
         { }
     virtual QWidget *createWidget(const QString &className, QWidget *parent = 0,
                                   const QString &name = QString())
     {
         if (className == QLatin1String("TetrixBoard")) {
             QWidget *board = new TetrixBoard(parent);
             board->setObjectName(name);
             return board;
         }
         return QUiLoader::createWidget(className, parent, name);
     }
};
*/




HB_FUNC( SCRIPT_1 )
{

QPushButton *button;

button = hb_param( 1, HB_IT_OBJECT ) ? qth_parPtr<QPushButton>( 1 ) : (QPushButton*) 0;

QScriptEngine engine;
QScriptValue js_btn = engine.newQObject( button);

engine.globalObject().setProperty("button", js_btn);

QScriptValue fun = engine.evaluate("(function(a, b) { return a * b; })");
QScriptValueList args;
args << hb_parnd(2) << hb_parnd(3);
 
     
QScriptEngineDebugger debugger;
debugger.attachTo(&engine);

QScriptValue ret = fun.call(QScriptValue(), args);

QScriptValue fun2 = evaluateFile(engine, "./script_1.js");
QScriptValue ret2 = fun2.call(QScriptValue(), args);


evaluateFile(engine, "./pdf.js");
evaluateFile(engine, "./pdf_1.js");


hb_retnd(ret.toNumber());

//QString x = "abc";
//qth_retPtr<QString>( x, "QString" );

//char *x = "returno stringo";

//hb_retc(x);
}

#pragma ENDDUMP

