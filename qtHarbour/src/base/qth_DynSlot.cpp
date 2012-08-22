/*
 * $Id: qth_DynSlot.cpp 98 2011-03-22 09:42:55Z tfonrouge $
 *
 * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/
 * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>
 *
 */

#include "qth_DynSlot.h"

/*
 connectDynSlot_Block
 Teo. Mexico 2011
 */
bool DynObject::connectDynSlot_Block( QObject *obj, const char *signal, PHB_ITEM pBlock, Qt::ConnectionType type )
{
    QByteArray theSignal = QMetaObject::normalizedSignature( signal );
    
    int signalId = obj->metaObject()->indexOfSignal( theSignal );

    if( signalId < 0 )
    {
        return false;
    }

    int slotId = slotBlockIdx.value( pBlock->item.asBlock.value, -1 );

    if( slotId < 0 ) 
    {
        slotId = slotList.size();
        slotBlockIdx[ pBlock->item.asBlock.value ] = slotId;
        slotList.append( new Slot( pBlock ) );
    }
    
    return QMetaObject::connect( obj, signalId, this, slotId + metaObject()->methodCount(), type );
}

/*
 connectDynSlot_Method
 Teo. Mexico 2011
 */
bool DynObject::connectDynSlot_Method( QObject *obj, const char* signal, PHB_ITEM receiver, const char* method, Qt::ConnectionType type )
{
    QByteArray theSignal = QMetaObject::normalizedSignature( signal );
    QByteArray theMethod = method;
    
    int signalId = obj->metaObject()->indexOfSignal( theSignal );
    
    if( signalId < 0 )
    {
        return false;
    }
    
    int slotId = slotMthdIdx.value( theMethod, -1 );
    
    if( slotId < 0 ) 
    {
        slotId = slotList.size();
        slotMthdIdx[ theMethod ] = slotId;
        slotList.append( new Slot( receiver, method ) );
    }
    
    return QMetaObject::connect( obj, signalId, this, slotId + metaObject()->methodCount(), type );
}

/*
 qt_metacall
 Teo. Mexico 2011
 */
int DynObject::qt_metacall( QMetaObject::Call _c, int _id, void** _a )
{
    _id = QObject::qt_metacall( _c, _id, _a );
    
    if( _id < 0 || _c != QMetaObject::InvokeMetaMethod )
    {
        return _id;
    }
    
    Q_ASSERT( _id < slotList.size() );
        
    slotList[ _id ]->call( sender(), _a );
    
    return -1;
}

Slot::Slot( PHB_ITEM _pBlock )
{
    pBlock = hb_itemNew( _pBlock );
    slotType = byBlock;
}

Slot::Slot( PHB_ITEM _pReceiver, const char* _methodName )
{
    pReceiver = hb_itemNew( NULL );
    hb_itemRawCpy( pReceiver, _pReceiver );
    pReceiver->type &= ~HB_IT_DEFAULT;
    methodName = _methodName;
    slotType = byMethod;
}

Slot::~Slot()
{
    switch (slotType)
    {
        case byBlock:
            hb_itemRelease( pBlock );
            break;
        case byMethod:
            hb_itemRelease( pReceiver );
            break;
        default:
            break;
    }
}

void Slot::call(QObject *sender, void **) 
{
    switch (slotType)
    {
        case byBlock:
            hb_vmEvalBlock( pBlock );
            break;
        case byMethod:
            hb_objSendMsg( pReceiver, methodName.data(), 0 );
            break;
        default:
            break;
    }
}

