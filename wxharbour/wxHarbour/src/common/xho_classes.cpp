/*
 * $Id: xho_classes.cpp 663 2010-11-24 15:32:06Z tfonrouge $
 */

#ifdef QTHARBOUR_LIBRARY
#include "qtharbour.h"
#else
#include "wxh.h"
#endif

static MAP_PHB_BASEARRAY hashPHB_BASEARRAY;
static MAP_XHOOBJECT hashXHOObject;
static MAP_CRC32 map_crc32;

static PHB_ITEM lastTopLevelWindow;

/*
 destructor
 Teo. Mexico 2009
 */
xho_Item::~xho_Item()
{
    hashPHB_BASEARRAY.erase( hashPHB_BASEARRAY.find( m_pBaseArray ) );
    hashXHOObject.erase( hashXHOObject.find( m_xhoObject ) );
    
    if( map_crc32.find( uiProcNameLine ) != map_crc32.end() )
        map_crc32.erase( map_crc32.find( uiProcNameLine ) );
    
    /* release codeblocks stored in event list */
    if( evtList.size() > 0 )
    {
        for( vector<PCONN_PARAMS>::iterator it = evtList.begin(); it < evtList.end(); it++ )
        {
            PCONN_PARAMS pConnParams = *it;
            if( pConnParams->pItmActionBlock )
            {
                hb_itemRelease( pConnParams->pItmActionBlock );
                pConnParams->pItmActionBlock = NULL;
            }
            delete pConnParams;
        }
    }
    
    if( delete_Xho )
    {
        if( m_xhoObject )
            delete m_xhoObject;
    }
    if( pSelf )
    {
        hb_objSendMsg( pSelf, "ClearObjData", 0 );
        hb_itemRelease( pSelf );
        pSelf = NULL;
    }
}

/*
 constructor
 Teo. Mexico 2009
 */
xho_ObjParams::xho_ObjParams( PHB_ITEM pHbObj )
{
    pParamParent = NULL;
    linkChildParentParams = false;
    if( pHbObj == NULL )
        pSelf = hb_stackSelfItem();
    else
        pSelf = pHbObj;
    pXho_Item = xho_itemListGet_PXHO_ITEM( pSelf );
}

/*
 destructor
 Teo. Mexico 2009
 */
xho_ObjParams::~xho_ObjParams()
{
    ProcessParamLists();
}

/*
 Get_xhoObject
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::Get_xhoObject()
{
    return xho_itemListGet_XHO( pSelf );
}

/*
 param
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::param( const int param )
{
    return xho_par_XhoObject( param );
}

/*
 paramChild
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::paramChild( PHB_ITEM pChildItm )
{
    xhoObject* m_xhoObject = NULL;
    
    if( pChildItm )
    {
        m_xhoObject = xho_itemListGet_XHO( pChildItm );
        
        if( m_xhoObject )
        {
            map_paramListChild[ pChildItm ] = m_xhoObject;
            linkChildParentParams = true;
        }
    }
    
    return m_xhoObject;
}

/*
 paramChild
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::paramChild( const int param )
{
    return paramChild( hb_param( param, HB_IT_OBJECT ) );
}

/*
 paramParent
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::paramParent( PHB_ITEM pParentItm )
{
    xhoObject* m_xhoObject = NULL;
    
    if( pParentItm )
    {
        m_xhoObject = xho_itemListGet_XHO( pParentItm );
        
        if( m_xhoObject )
        {
            if( this->pParamParent == NULL )
                this->pParamParent = pParentItm;
            else
                hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 3, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
            linkChildParentParams = true;
        }
    }
    
    return m_xhoObject;
}

/*
 paramParent
 Teo. Mexico 2009
 */
xhoObject* xho_ObjParams::paramParent( const int param )
{
    return paramParent( hb_param( param, HB_IT_OBJECT ) );
}

/*
 ProcessParamLists
 Teo. Mexico 2009
 */
void xho_ObjParams::ProcessParamLists()
{
    if( linkChildParentParams )
    {
        /* add the Parent object (if any) to the child/parent lists */
        if( ( xho_itemListGet_PXHO_ITEM( pSelf ) != NULL ) )
        {
            SetChildItem( pSelf );
        }
        
        /* add the Child objects to the child/parent lists */
        while( map_paramListChild.size() > 0 )
        {
            MAP_PHB_ITEM::iterator it = map_paramListChild.begin();
#ifdef QTHARBOUR_LIBRARY
            SetChildItem( it.key() );
#else
            SetChildItem( it->first );
#endif
            map_paramListChild.erase( it );
        }
        
        linkChildParentParams = false;
    }
}

/*
 Return
 Teo. Mexico 2009
 */
void xho_ObjParams::Return( xhoObject* xhoObj, bool bItemRelease )
{
    /* checks for a valid new pSelf object */
    if( pSelf && ( hashPHB_BASEARRAY.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) == hashPHB_BASEARRAY.end() ) )
    {
        pXho_Item = NULL;
        PHB_ITEM pItem = NULL;
        
        pXho_Item = new xho_Item;
        pXho_Item->nullObj = false;
        pXho_Item->m_xhoObject = xhoObj;
        pXho_Item->uiClass = hb_objGetClass( pSelf );
        pXho_Item->m_pBaseArray = (HB_BASEARRAY *) hb_arrayId( pSelf );
        
        /* Objs derived from wxTopLevelWindow are not volatile to local */
        if( hb_clsIsParent( hb_objGetClass( pSelf ), xhoTopLevelWindow ) )
        {
            /* calculate the crc32 for the procname/procline/uiClass that created this obj */
            char szName[ HB_SYMBOL_NAME_LEN + HB_SYMBOL_NAME_LEN + 5 ];
            UINT uiProcOffset = 1;
            USHORT usProcLine = 0;
            
            hb_procname( uiProcOffset, szName, TRUE );
            if( strncmp( "__WXH_", szName, 6 ) == 0 )
                hb_procname( ++uiProcOffset, szName, TRUE );
            
            long lOffset = hb_stackBaseProcOffset( uiProcOffset );
            if( lOffset > 0 )
                usProcLine = hb_stackItem( lOffset )->item.asSymbol.stackstate->uiLineNo;
            
            UINT uiCrc32 = hb_crc32( (long) hb_objGetClass( pSelf ) + usProcLine, (const char *) szName, strlen( szName ) );
            
            //			 qoutf("METHODNAME: %s:%d, crc32: %u", szName, usProcLine, uiCrc32 );
            
            /* check if we are calling again the obj creation code and a xho_Item exists */
            if( map_crc32.find( uiCrc32 ) != map_crc32.end() )
            {
                delete map_crc32[ uiCrc32 ];
            }
            
            map_crc32[ uiCrc32 ] = pXho_Item;
            pXho_Item->uiProcNameLine = uiCrc32;
            
            //pItem = wxh_itemNullObject( pSelf );
            //pXho_Item->nullObj = true;
            pItem = hb_itemNew( pSelf );
            lastTopLevelWindow = pItem;
        }
        
        if( pItem )
        {
            pXho_Item->pSelf = pItem;
        }
        
        hashPHB_BASEARRAY[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ] = pXho_Item;
        hashXHOObject[ xhoObj ] = pXho_Item;
        
        linkChildParentParams = true;
        ProcessParamLists();
        
        hb_objSendMsg( pSelf, "OnCreate", 0 );
        
        if( hb_stackReturnItem() != pSelf )
        {
            hb_itemReturn( pSelf );
        }
        
        if( bItemRelease )
            hb_itemRelease( pSelf );
        
    }else
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 4, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
 SetChildItem
 Teo. Mexico 2009
 */
void xho_ObjParams::SetChildItem( const PHB_ITEM pChildItm )
{
    xho_Item* pWxh_ItemChild = xho_itemListGet_PXHO_ITEM( pChildItm );
    
    if( pWxh_ItemChild )
    {
        if( pWxh_ItemChild->pSelf == NULL )
        {
            pWxh_ItemChild->pSelf = hb_itemNew( pChildItm );
        }
        else
            pWxh_ItemChild->uiRefCount++;
    }else
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 2, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
 End Class xho_ObjParams
 */

/*
 * XHO functions
 */

/*
 xho_itemListDel_XHO
 Teo. Mexico 2009
 */
void xho_itemListDel_XHO( xhoObject* wxObj, bool bDeleteWxObj )
{
    xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( wxObj );
    
    if( pXho_Item )
    {
        pXho_Item->delete_Xho = bDeleteWxObj;
        delete pXho_Item;
    }
}

/*
 xho_itemListGet_HB
 Teo. Mexico 2009
 */
PHB_ITEM xho_itemListGet_HB( xhoObject* wxObj )
{
    PHB_ITEM pSelf = NULL;
    
    if( wxObj )
    {
        xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( wxObj );
        
        if( pXho_Item )
        {
            pSelf = pXho_Item->pSelf;
            if( hb_itemType( pSelf ) != HB_IT_OBJECT )
                pSelf = NULL;
        }
        else {
#ifdef QTHARBOUR_LIBRARY
            QString clsName( wxObj->metaObject()->className() );
#else
            wxString clsName( wxObj->GetClassInfo()->GetClassName() );
#endif
            //const char *ascii = clsName.ToAscii();
            //qoutf("xho_itemListGet_HB (no xho_Item): %s", ascii );
        }
    }
    return pSelf;
}

/*
 xho_itemListGet_PXHO_ITEM
 Teo. Mexico 2009
 */
xho_Item* xho_itemListGet_PXHO_ITEM( PHB_ITEM pSelf )
{
    xho_Item* pXho_Item = NULL;
    
    if( pSelf && ( hashPHB_BASEARRAY.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) != hashPHB_BASEARRAY.end() ) )
    {
        pXho_Item = hashPHB_BASEARRAY[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ];
    }
    
    return pXho_Item;
}

/*
 xho_itemListGet_PXHO_ITEM
 Teo. Mexico 2009
 */
xho_Item* xho_itemListGet_PXHO_ITEM( xhoObject* m_xhoObject )
{
    xho_Item* pXho_Item = NULL;
    
    if( m_xhoObject && ( hashXHOObject.find( m_xhoObject ) != hashXHOObject.end() ) )
    {
        pXho_Item = hashXHOObject[ m_xhoObject ];
    }
    
    return pXho_Item;
}

/*
 xho_itemListGet_XHO
 Teo. Mexico 2009
 */
xhoObject* xho_itemListGet_XHO( PHB_ITEM pSelf, const char* inheritFrom )
{
    xhoObject* m_xhoObject = NULL;
    
    
    if( inheritFrom == NULL || hb_clsIsParent( hb_objGetClass( pSelf ), inheritFrom ) )
    {
        if( pSelf && ( hashPHB_BASEARRAY.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) != hashPHB_BASEARRAY.end() ) )
        {
            m_xhoObject = hashPHB_BASEARRAY[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ]->m_xhoObject;
        }
    }

    return m_xhoObject;
}

/*
 xho_itemListReleaseAll
 Teo. Mexico 2009
 */
void xho_itemListReleaseAll()
{
    MAP_XHOOBJECT::iterator it;
    
    while( ! hashXHOObject.empty() )
    {
        it = hashXHOObject.begin();
#ifdef QTHARBOUR_LIBRARY
        it.value()->delete_Xho = false;
        delete it.value();
#else
        it->second->delete_Xho = false;
        delete it->second;
#endif
        //xho_itemListDel_XHO( it->first );
    }
}

/*
 xho_itemListSwap
 Teo. Mexico 2009
 */
bool xho_itemListSwap( xhoObject *oldObj, xhoObject *newObj )
{
    xho_Item *pXho_Item = xho_itemListGet_PXHO_ITEM( oldObj );
    
    if( pXho_Item )
    {
        pXho_Item->m_xhoObject = newObj;
        hashXHOObject.erase( hashXHOObject.find( oldObj ) );
        hashXHOObject[ newObj ] = pXho_Item;
        delete oldObj;
        return true;
    }
    return false;
}

/*
 xho_itemNewReturn
 Teo. Mexico 2009
 */
void xho_itemNewReturn( const char * szClsName, xhoObject* ctrl, xhoObject* parent )
{
    PHB_ITEM pSelf = xho_itemListGet_HB( ctrl );
    
    if( pSelf == NULL )
    {
        PHB_DYNS pDynSym = hb_dynsymFindName( szClsName );
        
        if( pDynSym )
        {
            hb_vmPushDynSym( pDynSym );
            hb_vmPushNil();
            hb_vmDo( 0 );
            
            pSelf = hb_itemNew( hb_stackReturnItem() );
            
            xho_ObjParams objParams = xho_ObjParams( pSelf );
            
            if( parent )
                objParams.paramParent( xho_itemListGet_HB( parent ) );
            
            objParams.Return( ctrl, true );
        }
    }
    else
    {
        hb_itemReturn( pSelf );
    }
}

/*
 xho_itemReturn
 Teo. Mexico 2009
 */
void xho_itemReturn( xhoObject *xhoObj )
{
    hb_itemReturn( xho_itemListGet_HB( xhoObj ) );
}

/*
 xho_par_arrayInt
 Teo. Mexico 2010
 */
void xho_par_arrayInt( int param, int* arrayInt, const size_t len )
{
    
    if( ISARRAY( param ) )
    {
        PHB_ITEM pArray = hb_param( param, HB_IT_ARRAY );
        PHB_ITEM pItm;
        ULONG ulLen = min( (size_t) hb_arrayLen( pArray ), len );
        for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
        {
            pItm = hb_arrayGetItemPtr( pArray, ulI );
            if( hb_itemType( pItm ) && HB_IT_NUMERIC )
            {
                arrayInt[ ulI - 1 ] = hb_arrayGetNI( pArray, ulI );
            }
        }
    }
    
}

/*
 xho_par_XhoObject
 Teo. Mexico 2009
 */
xhoObject* xho_par_XhoObject( const int param, const char* inheritFrom )
{
    PHB_ITEM hbObj = hb_param( param, HB_IT_OBJECT );
    xhoObject* object = NULL;
    
    if( hbObj )
    {
        object = xho_itemListGet_XHO( hbObj, inheritFrom );
    }
    return object;
}

/*
 * Harbour functions
 */

/*
 * wxh_LastTopLevelWindow
 * Teo. Mexico 2009
 */
HB_FUNC( WXH_LASTTOPLEVELWINDOW )
{
    hb_itemReturn( lastTopLevelWindow );
}


/*
 * other functions
 */

/*
 qoutf
 Teo. Mexico 2009
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
 Teo. Mexico 2009
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
