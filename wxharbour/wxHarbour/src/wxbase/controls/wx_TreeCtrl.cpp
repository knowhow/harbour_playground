/*
 * $Id: wx_TreeCtrl.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_TreeCtrl
    Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_TreeCtrl.h"

extern "C"
{
    void HB_FUN_WXTREEITEMID( void );
}

/*
    ~wx_TreeCtrl
    Teo. Mexico 2008
*/
wx_TreeCtrl::~wx_TreeCtrl()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXTREECTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = wxh_par_wxPoint( 3 );
    const wxSize& size = wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxTR_HAS_BUTTONS : hb_parnl( 5 );
    const wxValidator& validator = ISNIL( 6 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 6 ) );
    const wxString& name = wxh_parc( 7 );
    wx_TreeCtrl* treeCtrl = new wx_TreeCtrl( parent, id, pos, size, style, validator, name );

    objParams.Return( treeCtrl );
}

/*
    wxTreeCtrl:AddRoot
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ADDROOT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) objParams.Get_xhoObject();

    const wxString& text = wxh_parc( 1 );
    int image = ISNIL( 2 ) ? -1 : hb_parni( 2 );
    int selImage = ISNIL( 3 ) ? -1 : hb_parni( 3 );
    wxTreeItemData* data = (wxTreeItemData *) objParams.paramParent( 4 );

    if( treeCtrl )
    {
        wxTreeItemId treeItemId = treeCtrl->AddRoot( text, image, selImage, data );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:AppendItem
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_APPENDITEM )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) objParams.Get_xhoObject();

    wxTreeItemId parent = wxTreeItemId( (void *) hb_parnl( 1 ) );
    const wxString& text = wxh_parc( 2 );
    int image = ISNIL( 3 ) ? -1 : hb_parni( 3 );
    int selImage = ISNIL( 4 ) ? -1 : hb_parni( 4 );
    wxTreeItemData* data = (wxTreeItemData *) objParams.paramParent( 5 );

    if( treeCtrl && parent )
    {
        wxTreeItemId treeItemId = treeCtrl->AppendItem( parent, text, image, selImage, data );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:Delete
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_DELETE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->Delete( item );
    }
}

/*
    wxTreeCtrl:DeleteAllItems
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_DELETEALLITEMS )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        treeCtrl->DeleteAllItems();
    }
}

/*
    wxTreeCtrl:DeleteChildren
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_DELETECHILDREN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->DeleteChildren( item );
    }
}

/*
    wxTreeCtrl:Collapse
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_COLLAPSE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->Collapse( item );
    }
}

/*
    wxTreeCtrl:CollapseAll
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_COLLAPSEALL )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        treeCtrl->CollapseAll();
    }
}

/*
    wxTreeCtrl:CollapseAllChildren
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_COLLAPSEALLCHILDREN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->CollapseAllChildren( item );
    }
}

/*
    wxTreeCtrl:EnsureVisible
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ENSUREVISIBLE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->EnsureVisible( item );
    }
}

/*
    wxTreeCtrl:Expand
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_EXPAND )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->Expand( item );
    }
}

/*
    wxTreeCtrl:ExpandAll
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_EXPANDALL )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        treeCtrl->ExpandAll();
    }
}

/*
    wxTreeCtrl:ExpandAllChildren
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_EXPANDALLCHILDREN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        treeCtrl->ExpandAllChildren( item );
    }
}

/*
    wxTreeCtrl:GetChildrenCount
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETCHILDRENCOUNT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        bool recursively = ISNIL( 2 ) ? true : hb_parl( 2 );
        hb_retnl( treeCtrl->GetChildrenCount( item, recursively ) );
    }
}

/*
    wxTreeCtrl:GetCount
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETCOUNT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        hb_retnl( treeCtrl->GetCount() );
    }
}

/*
    wxTreeCtrl:GetFirstChild
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETFIRSTCHILD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    wxTreeItemIdValue cookie;

    if( ( hb_pcount() != 2 ) || !( ISBYREF( 2 ) ) )
    {
        hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
        return;
    }

    if( !ISNUM( 2 ) )
    {
        hb_stornl( 0, 2 );
    }

    if( treeCtrl && item )
    {
        cookie = &( hb_param( 2, HB_IT_NUMERIC )->item.asLong.value );
        wxTreeItemId treeItemId = treeCtrl->GetFirstChild( item, cookie );
        if( treeItemId )
        {
            hb_stornl( (long int) cookie, 2 );
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetItemParent
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETITEMPARENT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetItemParent( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetLastChild
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETLASTCHILD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetLastChild( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetNextChild
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETNEXTCHILD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    wxTreeItemIdValue cookie;

    if( ( hb_pcount() != 2 ) || !( ISBYREF( 2 ) ) )
    {
        hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
        return;
    }

    if( !ISNUM( 2 ) )
    {
        hb_stornl( 0, 2 );
    }

    if( treeCtrl && item )
    {
        cookie = &( hb_param( 2, HB_IT_NUMERIC )->item.asLong.value );
        wxTreeItemId treeItemId = treeCtrl->GetNextChild( item, cookie );
        if( treeItemId )
        {
            hb_stornl( (long int) cookie, 2 );
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetNextSibling
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETNEXTSIBLING )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetNextSibling( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetNextVisible
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETNEXTVISIBLE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetNextVisible( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetPrevSibling
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETPREVSIBLING )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetPrevSibling( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetPrevVisible
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETPREVVISIBLE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        wxTreeItemId treeItemId = treeCtrl->GetPrevVisible( item );
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:GetRootItem
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_GETROOTITEM )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        wxTreeItemId treeItemId = treeCtrl->GetRootItem();
        if( treeItemId )
        {
            hb_retnl( (long int) treeItemId.m_pItem );
        }
    }
}

/*
    wxTreeCtrl:IsEmpty
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ISEMPTY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    if( treeCtrl )
    {
        hb_retl( treeCtrl->IsEmpty() );
    }
}

/*
    wxTreeCtrl:IsExpanded
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ISEXPANDED )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        hb_retl( treeCtrl->IsExpanded( item ) );
    }
}

/*
    wxTreeCtrl:IsSelected
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ISSELECTED )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        hb_retl( treeCtrl->IsSelected( item ) );
    }
}

/*
    wxTreeCtrl:IsVisible
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ISVISIBLE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        hb_retl( treeCtrl->IsVisible( item ) );
    }
}

/*
    wxTreeCtrl:ItemHasChildren
    Teo. Mexico 2008
*/
HB_FUNC( WXTREECTRL_ITEMHASCHILDREN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxTreeCtrl* treeCtrl = (wxTreeCtrl *) xho_itemListGet_XHO( pSelf );

    wxTreeItemId item = wxTreeItemId( (void *) hb_parnl( 1 ) );

    if( treeCtrl && item )
    {
        hb_retl( treeCtrl->ItemHasChildren( item ) );
    }
}
