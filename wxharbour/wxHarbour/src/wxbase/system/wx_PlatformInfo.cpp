/*
 * $Id: wx_PlatformInfo.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_PlatformInfo: Implementation
 Teo. Mexico 2010
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_PlatformInfo.h"

/*
 ~wx_PlatformInfo
 Teo. Mexico 2010
 */
wx_PlatformInfo::~wx_PlatformInfo()
{
//	xho_itemListDel_XHO( this );
}

/*
 Constructor: wxPlatformInfo Object
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    const wxPlatformInfo* platInfo =  &(wxPlatformInfo::Get());
    
    objParams.Return( (wxObject *) platInfo );
}

/*
    CheckOSVersion
    Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_CHECKOSVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retl( platInfo->CheckOSVersion( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
    CheckToolkitVersion
    Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_CHECKTOOLKITVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retl( platInfo->CheckToolkitVersion( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
 GetArch
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETARCH )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetArch( wxh_parc( 1 ) ) );
}

/*
 GetArchName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETARCHNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetArchName( (wxArchitecture) hb_parni( 1 ) ) );
        else
            wxh_retc( platInfo->GetArchName() );
    }
}

/*
 GetArchitecture
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETARCHITECTURE )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetArchitecture() );
}

/*
 GetEndianness
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETENDIANNESS )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            hb_retni( platInfo->GetEndianness( wxh_parc( 1 ) ) );
        else
            hb_retni( platInfo->GetEndianness() );
    }
}

/*
 GetEndiannessName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETENDIANNESSNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetEndiannessName( (wxEndianness) hb_parni( 1 ) ) );
        else
            wxh_retc( platInfo->GetEndiannessName() );
    }
}

/*
 GetOSMajorVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETOSMAJORVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetOSMajorVersion() );
}

/*
 GetOSMinorVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETOSMINORVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetOSMinorVersion() );
}

/*
 GetOperatingSystemFamilyName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETOPERATINGSYSTEMFAMILYNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetOperatingSystemFamilyName( (wxOperatingSystemId) hb_parni( 1 ) ) );
        else
            wxh_retc( platInfo->GetOperatingSystemFamilyName() );
    }
}

/*
 GetOperatingSystemId
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETOPERATINGSYSTEMID )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            hb_retni( platInfo->GetOperatingSystemId( wxh_parc( 1 ) ) );
        else
            hb_retni( platInfo->GetOperatingSystemId() );
    }
}

/*
 GetOperatingSystemIdName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETOPERATINGSYSTEMIDNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetOperatingSystemIdName( (wxOperatingSystemId) hb_parni( 1 ) ) );
        else
            wxh_retc( platInfo->GetOperatingSystemIdName() );
    }
}

/*
 GetPortId
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETPORTID )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            hb_retni( platInfo->GetPortId( wxh_parc( 1 ) ) );
        else
            hb_retni( platInfo->GetPortId() );
    }
}

/*
 GetPortIdName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETPORTIDNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetPortIdName( (wxPortId) hb_parni( 1 ), hb_parl( 2 ) ) );
        else
            wxh_retc( platInfo->GetPortIdName() );
    }
}

/*
 GetPortIdShortName
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETPORTIDSHORTNAME )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
    {
        if( hb_pcount() > 0 )
            wxh_retc( platInfo->GetPortIdShortName( (wxPortId) hb_parni( 1 ), hb_parl( 2 ) ) );
        else
            wxh_retc( platInfo->GetPortIdShortName() );
    }
}

/*
 GetToolkitMajorVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETTOOLKITMAJORVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetToolkitMajorVersion() );
}

/*
 GetToolkitMinorVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_GETTOOLKITMINORVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retni( platInfo->GetToolkitMinorVersion() );
}

/*
 IsOk
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_ISOK )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retl( platInfo->IsOk() );
}

/*
 IsUsingUniversalWidgets
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_ISUSINGUNIVERSALWIDGETS )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        hb_retl( platInfo->IsUsingUniversalWidgets() );
}

/*
 SetArchitecture
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETARCHITECTURE )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetArchitecture( (wxArchitecture) hb_parni( 1 ) );
}

/*
 SetEndianness
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETENDIANNESS )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetEndianness( (wxEndianness) hb_parni( 1 ) );
}

/*
 SetOSVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETOSVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetOSVersion( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
 SetOperatingSystemId
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETOPERATINGSYSTEMID )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetOperatingSystemId( (wxOperatingSystemId) hb_parni( 1 ) );
}

/*
 SetPortId
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETPORTID )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetPortId( (wxPortId) hb_parni( 1 ) );
}

/*
 SetToolkitVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXPLATFORMINFO_SETTOOLKITVERSION )
{
    wxPlatformInfo* platInfo = (wxPlatformInfo *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( platInfo )
        platInfo->SetToolkitVersion( hb_parni( 1 ), hb_parni( 2 ) );
}
