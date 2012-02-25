/*
 * $Id: xho_classes.h 743 2011-07-27 18:26:08Z tfonrouge $
 */

void          xho_itemListDel_XHO( xhoObject* wxObj, bool bDeleteWxObj = false );
xho_Item*     xho_itemListGet_PXHO_ITEM( xhoObject* wxObj );
xho_Item*     xho_itemListGet_PXHO_ITEM( PHB_ITEM pSelf );
PHB_ITEM      xho_itemListGet_HB( xhoObject* wxObj );
xhoObject*    xho_itemListGet_XHO( PHB_ITEM pSelf, const char* inheritFrom = NULL );
void          xho_itemListReleaseAll();
bool          xho_itemListSwap( xhoObject *oldObj, xhoObject *newObj );
void          xho_itemNewReturn( const char * szClsName, xhoObject* ctrl, xhoObject* parent = NULL );
void          xho_itemReturn( xhoObject* wxObj );
void          xho_par_arrayInt( int param, int* arrayInt, const size_t len );
xhoObject*    xho_par_XhoObject( int param, const char* inheritFrom = NULL );

/* generic qoutf for debug output */
void qoutf( const char* format, ... );
void qqoutf( const char* format, ... );

typedef struct _CONN_PARAMS
{
    bool force;
    int id;
    int lastId;
    xhoEventType eventType;
    PHB_ITEM pItmActionBlock;
} CONN_PARAMS, *PCONN_PARAMS;

/*
 xho_Item class : Holds PHB_ITEM's and the eXtended Harbour Object associated
 */
class xho_Item
{
public:
    bool delete_Xho;
    bool nullObj;
    xhoObject* m_xhoObject;
    HB_USHORT uiClass;
    PHB_BASEARRAY m_pBaseArray;
    vector<PCONN_PARAMS> evtList;
    PHB_ITEM pSelf;
    HB_USHORT uiRefCount;
    HB_UINT uiProcNameLine;
    
    xho_Item() { delete_Xho = true; uiClass = 0; pSelf = NULL ; uiRefCount = 0; uiProcNameLine = 0; }
    ~xho_Item();
};

class xho_ObjParams
{
private:
    bool linkChildParentParams;
    void SetChildItem( const PHB_ITEM pChildItem );
public:

    PHB_ITEM pParamParent;
    MAP_PHB_ITEM map_paramListChild;

    PHB_ITEM pSelf;
    xho_Item* pXho_Item;

    xho_ObjParams( PHB_ITEM pHbObj );
    ~xho_ObjParams();

    void ProcessParamLists();

    void Return( xhoObject* wxObj, bool bItemRelease = false );

    xhoObject* param( int param );
    xhoObject* paramChild( PHB_ITEM pChildItm );
    xhoObject* paramChild( int param );
    xhoObject* paramParent( PHB_ITEM pParentItm );
    xhoObject* paramParent( int param );

    xhoObject* Get_xhoObject();

};
