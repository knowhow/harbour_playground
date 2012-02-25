/*
 * $Id: wx_Bitmap.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_Bitmap: Implementation
 Teo. Mexico 2009
 */

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Bitmap.h"

/* XPM */
static const char * missimg_xpm[] = {
/* columns rows colors chars-per-pixel */
"32 32 5 1",
"X c Black",
"o c #FFFFFF",
"  c None",
". c #C0C0C0",
"O c #E0E0E0",
/* pixels */
" .............................X ",
" .ooooooooooooooooooooooooooooX ",
" .ooooooooooooooooooooooooooooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOXOOOOOOOOOOOOOOOOooX ",
" XXXOOOOOXX XOOOOOOOOOOOOOOOooX ",
"    XXXXX    XOOOOOOOOOOOOOOooX ",
"              XOOOXXXOOOOOOOooX ",
"               XXX   XXOOOOOooX ",
"                       XOOOOooX ",
" .                      XOOOooX ",
" ..                      XXOooX ",
" .o..                      XooX ",
" .ooO...                    XXX ",
" .ooOOOO..........              ",
" .ooOOOOOOOOOOOOOO..            ",
" .ooOOOOOOOOOOOOOOOO..          ",
" .ooOOOOOOOOOOOOOOOOOO......... ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooOOOOOOOOOOOOOOOOOOOOOOOOooX ",
" .ooooooooooooooooooooooooooooX ",
" .ooooooooooooooooooooooooooooX ",
" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX "
};

/* XPM */
static const char * find_xpm[] = {
/* columns rows colors chars-per-pixel */
"16 15 41 1",
"y c #A06959",
"9 c #A7DAF2",
"$ c #B5CAD7",
"> c #35B4E1",
"t c #6B98B8",
"w c #B6E0F4",
"q c #AEC9D7",
"1 c #5A89A6",
"+ c #98B3C6",
"4 c #EAF6FC",
"3 c #DEF1FA",
"= c #4CBCE3",
"d c #DB916B",
"X c #85A7BC",
"s c #D8BCA4",
"o c #749BB4",
"e c #BCD9EF",
"* c #62B4DD",
"< c #91D2EF",
"a c #E6DED2",
"0 c #E9F4FB",
"  c None",
"@ c #A0BACB",
"O c #AABFCD",
"i c #6591AE",
": c #B9CBD5",
"- c #71C5E7",
"5 c #D3ECF8",
"% c #81A3B9",
"6 c #8AD0EE",
"8 c #FDFDFE",
"p c #8EA9BC",
"r c #B6D5EE",
", c #81CCEB",
". c #ACC4D3",
"; c #AFD1DE",
"7 c #EFF8FC",
"u c #C2CBDB",
"# c #C0D1DC",
"2 c #CAD6E1",
"& c #8FB0C3",
/* pixels */
"       .XooXO   ",
"      +@###$+%  ",
"     .&#*==-;@@ ",
"     o:*>,<--:X ",
"     12>-345-#% ",
"     12>678392% ",
"     %$*,3059q& ",
"     @Oq,wwer@@ ",
"      t@q22q&+  ",
"    yyui+%o%p   ",
"   yasy         ",
"  yasdy         ",
" yasdy          ",
" ysdy           ",
"  yy            "
};

/*
 * getDefaultBitmap
 * Teo. Mexico 2009
 */
wx_Bitmap* getDefaultBitmap( int i )
{
    wx_Bitmap* bitmap;
    switch ( i ) {
    case 0 :
        bitmap = new wx_Bitmap( missimg_xpm );
        break;
    case 1 :
        bitmap = new wx_Bitmap( find_xpm );
        break;
    default:
        bitmap = (wx_Bitmap *) &wxNullBitmap;
        break;
    }
    return bitmap;
}

/*
 ~wx_Bitmap
 Teo. Mexico 2009
 */
wx_Bitmap::~wx_Bitmap()
{
    xho_itemListDel_XHO( this );
}

/*
 New
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wx_Bitmap* bitmap;
    
    switch( hb_pcount() )
    {
    case 0 :
        {
            bitmap = new wx_Bitmap();
        }
        break;
    case 1 :
        {
        if( ISNUM( 1 ) )
        {
        bitmap = getDefaultBitmap( hb_parni( 1 ) );
        }
        else
        {
        const char* bits = hb_parc( 1 );
        bitmap = new wx_Bitmap( &bits );
        }
        }
        break;
    case 2:
        {
            const wxString& name = wxh_parc( 1 );
            long type = hb_parnl( 2 );	  
            bitmap = new wx_Bitmap( name, type );
        }
        break;
    default :
        bitmap = new wx_Bitmap();
        break;
    }
    
    objParams.Return( bitmap );
}

/*
 wxBitmap:AddHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_ADDHANDLER )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    bitmap->AddHandler( (wxBitmapHandler *) xho_par_XhoObject( 1 ) );
    }
}

/*
 wxBitmap:CleanUpHandlers
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_CLEANUPHANDLERS )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    bitmap->CleanUpHandlers();
    }
}

/*
 wxBitmap:ConvertToImage
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_CONVERTTOIMAGE )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    wxImage image = bitmap->ConvertToImage();
    xho_itemReturn( &image );
    }
}

/*
 wxBitmap:CopyFromIcon
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_COPYFROMICON )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    const wxIcon& icon = *(wxIcon *) xho_par_XhoObject( 1 );
        hb_retl( bitmap->CopyFromIcon( icon ) );
    }
}

/*
 wxBitmap:GetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETDEPTH )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        hb_retni( bitmap->GetDepth() );
    }
}

/*
 wxBitmap:GetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETHEIGHT )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        hb_retni( bitmap->GetHeight() );
    }
}

/*
 wxBitmap:GetMask
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETMASK )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        xho_itemReturn( bitmap->GetMask() );
    }
}

/*
 wxBitmap:GetPalette
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETPALETTE )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        xho_itemReturn( bitmap->GetPalette() );
    }
}

/*
 wxBitmap:GetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETWIDTH )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        hb_retni( bitmap->GetWidth() );
    }
}

/*
 wxBitmap:InitStandardHandlers
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_INITSTANDARDHANDLERS )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        bitmap->InitStandardHandlers();
    }
}

/*
 wxBitmap:InsertHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_INSERTHANDLER )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    bitmap->InsertHandler( (wxBitmapHandler *) xho_par_XhoObject( 1 ) );
    }
}

/*
 wxBitmap:IsOk
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_ISOK )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        hb_retl( bitmap->IsOk() );
    }
}

/*
 wxBitmap:LoadFile
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_LOADFILE )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        if( HB_ISNIL( 2 ) )
            hb_retl( bitmap->LoadFile( wxh_parc( 1 ) ) );
        else
            hb_retl( bitmap->LoadFile( wxh_parc( 1 ), wxBitmapType( hb_parni( 2 ) ) ) );
    }
}

/*
 wxBitmap:RemoveHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_REMOVEHANDLER )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        hb_retl( bitmap->RemoveHandler( wxh_parc( 1 ) ) );
    }
}

/*
 wxBitmap:SaveFile
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SAVEFILE )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    wxPalette *palette = ISNIL( 3 ) ? NULL : (wxPalette *) xho_par_XhoObject( 3 );
        hb_retl( bitmap->SaveFile( wxh_parc( 1 ), (wxBitmapType) hb_parni( 2 ), palette ) );
    }
}

/*
 wxBitmap:SetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETDEPTH )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        bitmap->SetDepth( hb_parni( 1 ) );
    }
}

/*
 wxBitmap:SetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETHEIGHT )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        bitmap->SetHeight( hb_parni( 1 ) );
    }
}

/*
 wxBitmap:SetMask
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETMASK )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        bitmap->SetMask( (wxMask *) xho_par_XhoObject( 1 ) );
    }
}

/*
 wxBitmap:SetPalette
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETPALETTE )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
    const wxPalette& palette = * (wxPalette *) xho_par_XhoObject( 1 );
        bitmap->SetPalette( palette );
    }
}

/*
 wxBitmap:SetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETWIDTH )
{
    wxBitmap* bitmap = (wxBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmap )
    {
        bitmap->SetWidth( hb_parni( 1 ) );
    }
}
