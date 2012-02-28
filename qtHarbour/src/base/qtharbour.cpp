/*
 * $Id: qtharbour.cpp 106 2011-04-06 09:06:44Z tfonrouge $
 *
 * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/
 * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>
 *
 */

#include "qtharbour.h"

#include <QCoreApplication>

QtHarbour::QtHarbour()
{
}

/*
    qApp : emulates Qt macro qApp
    Teo. Mexico 2011
 */
HB_FUNC( QAPP )
{
    qth_itemReturn( qApp );
}

/*
 *
 */
HB_FUNC( QTH_BASEDESTRUCT )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );
    PQTH_ITEM pQthItem = qth_itemListGet_PQTH_ITEM( pSelf );
    
    if( pQthItem )
    {
        delete pQthItem;
    }
}

/*
 qth_errRT_PARAM
 Teo. Mexico 2011
 */
void qth_errRT_PARAM()
{
    hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );    
}

/*
 qth_ObjIsDerivedFrom
 Teo. Mexico 2011
 */
bool qth_ObjIsDerivedFrom( PHB_ITEM pSelf, const char* szClsName )
{
    return hb_clsIsParent( hb_objGetClass( pSelf ), szClsName );
}

/*
 * PARAMETERS values
 */

/*
 qth_IsArray
 Teo. Mexico 2010
 */
bool qth_IsArray( const int iParam )
{
    PHB_ITEM pArray = hb_param( iParam, HB_IT_ARRAY );
    return pArray && hb_objGetClass( pArray ) == 0;
}

/*
 qth_IsObject
 Teo. Mexico 2010
 */
bool qth_IsObject( const int iParam, const char* szClsName )
{
    return qth_ObjIsDerivedFrom( hb_param( iParam, HB_IT_OBJECT ), szClsName );
}

/*
 qth_IsVariant
 Teo. Mexico 2011
 */
bool qth_IsVariant( const int iParam )
{
    return hb_param( iParam, HB_IT_ANY );
}

/*
 qth_par_QString
 Teo. Mexico 2010
 */
QString qth_par_QString( const int iParam )
{
    QString string;
    //string.fromAscii( hb_parc( iParam ), -1 );
    string = hb_parc( iParam );
    return string;
}

/*
 qth_par_def
 Teo. Mexico 2010
 */
bool qth_par_def( const int iParam, long lMask )
{
    return HB_ISNIL( iParam ) || hb_param( iParam, lMask );
}

/*
 qth_par_def
 Teo. Mexico 2010
 */
bool qth_par_def( const int iParam, const char* szClsName )
{
    return HB_ISNIL( iParam ) || qth_IsObject( iParam, szClsName );
}

/*
 qth_par_ObjDerivedFrom
 Teo. Mexico 2010
 */
PHB_ITEM qth_par_ObjDerivedFrom( const int iParam, const char* szClsName )
{
    PHB_ITEM pSelf = hb_param( iParam, HB_IT_OBJECT );
    
    if( pSelf && qth_ObjIsDerivedFrom( pSelf, szClsName ) )
    {
        return pSelf;
    }
    return NULL;
}

/*
 qth_par_QthItem
 Teo. Mexico 2010
 */
PQTH_ITEM qth_par_QthItem( const int iParam )
{
    PHB_ITEM pSelf = hb_param( iParam, HB_IT_OBJECT );
    PQTH_ITEM qthItem = NULL;
    
    if( pSelf )
    {
        qthItem = qth_itemListGet_PQTH_ITEM( pSelf );
    }
    return qthItem;
}

/*
 qth_par_QthObject
 Teo. Mexico 2010
 */
PCPP_OBJECT qth_par_QthObject( const int iParam, const char* inheritFrom )
{
    PHB_ITEM hbObj = hb_param( iParam, HB_IT_OBJECT );
    PCPP_OBJECT cppObj = NULL;
    
    if( hbObj )
    {
        cppObj = qth_itemListGet_CPP( hbObj, inheritFrom );
    }
    return cppObj;
}

/*
 qth_par_QVariant
 Teo. Mexico 2011
 */
QVariant qth_par_QVariant( const int iParam )
{
    PHB_ITEM pItem = hb_param( iParam, HB_IT_ANY );
    
    QVariant variant;

    switch( hb_itemType( pItem )  )
    {
        case HB_IT_INTEGER:
            return QVariant( hb_itemGetNI( pItem ) );
            break;
        case HB_IT_ARRAY:
            if( hb_objGetClass( pItem ) == 0 )
            {
                
            }
            else
            {
                QSize* size = (QSize *) qth_itemListGet_CPP( pItem, "QSize" );
                if( size )
                {
                    return QVariant( *size );
                }
                QPoint* point = (QPoint *) qth_itemListGet_CPP( pItem, "QPoint" );
                if( point )
                {
                    return QVariant( *point );
                }
            }
            break;

        default:
            break;
    }
    return variant;
}

/*
 qth_parConstRef_QStringList
 Teo. Mexico 2010
 */
const QStringList& qth_parConstRef_QStringList( const int iParam )
{
    QStringList* stringList = new QStringList;
    PHB_ITEM pArray = hb_param( iParam, HB_IT_ARRAY );
    
    if( pArray )
    {
        ULONG ulLen = hb_arrayLen( pArray );
        for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
        {
            stringList->append( hb_arrayGetCPtr( pArray, ulI ) );
        }
    }
    return *stringList;
}

/*
 * RETURN values
 */

/*
 qth_ret_QString
 Teo. Mexico 2010
 */
void qth_ret_QString( const QString& string )
{
    hb_retc( string.toAscii() );
}

/*
 qth_par_WId
 Teo. Mexico 2011
 */
WId qth_par_WId( const int iParam )
{
#if defined( __MAC__ )
    return (WId) hb_parni( iParam );
#elif defined( __UNIX__ )
    return (WId) hb_parnl( iParam );
#else
    return (WId) hb_parptr( iParam );
#endif
}

/*
 qth_ret_WId
 Teo. Mexico 2010
 */
void qth_ret_WId( WId id )
{
#if defined( __MAC__ )
    hb_retni( id );
#elif defined( __UNIX__ )
    hb_retnl( id );
#else
    hb_retptr( id );
#endif
}

/*
 qth_set_param_QthItemFlag
 Teo. Mexico 2011
 */
void qth_set_param_QthItemFlag( PQTH_ITEM qthItem, QTHI_FLAG qthiFlag )
{
    switch ( qthiFlag ) 
    {
        /* there is not need to keep a (possible) copy of HB object */
        case QTHI_TRANSFER:
            qthItem->hbo_SetRefCount( false );
            qthItem->deleteCppObj = false; /* don't delete the C++ object, it belongs to someoneelse */
            break;
        case QTHI_TRANSFERBACK:
            qthItem->hbo_SetRefCount( false );
            qthItem->deleteCppObj = true; /* C++ object can be safely deleted, belongs to no one */
            break;

        default:
            break;
    }
}

/*
 * other functions
 */

/*
 qoutf
 Teo. Mexico 2010
 */
void qoutf( const char* format, ... )
{
    static char text[512];
    static PHB_DYNS s___qout = NULL;
    
    va_list argp;
    
    va_start( argp, format );
    vsprintf( text, format, argp );
    va_end( argp );
    
    if( s___qout == NULL )
    {
        s___qout = hb_dynsymGetCase( "QOUT" );
    }
    hb_vmPushDynSym( s___qout );
    hb_vmPushNil();
    hb_vmPushString( text, strlen( text ) );
    hb_vmDo( 1 );
}

/*
 qqoutf
 Teo. Mexico 2010
 */
void qqoutf( const char* format, ... )
{
    static char text[512];
    static PHB_DYNS s___qout = NULL;
    
    va_list argp;
    
    va_start( argp, format );
    vsprintf( text, format, argp );
    va_end( argp );
    
    if( s___qout == NULL )
    {
        s___qout = hb_dynsymGetCase( "QQOUT" );
    }
    hb_vmPushDynSym( s___qout );
    hb_vmPushNil();
    hb_vmPushString( text, strlen( text ) );
    hb_vmDo( 1 );
}
