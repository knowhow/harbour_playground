// Compatibility XLS functions

//#define _MSLINK_

#ifdef _MSLINK_

// Funct. cells

function xlsCELL(); return 1

function xlsSUM(); return 1
function xlsMULT(); return 1

// Funct. Math.

function xlsABS(); return 1
function xlsINTE(); return 1
function xlsMOD(); return 1
function xlsROUND(); return 1
function xlsSIGN(); return 1

function xlsSQRT(); return 1
function xlsEXP(); return 1
function xlsLN(); return 1
function xlsLOG(); return 1

function xlsPI(); return 1
function xlsRANDOM(); return 1

function xlsSIN(); return 1
function xlsCOS(); return 1
function xlsTAN(); return 1
function xlsASIN(); return 1
function xlsACOS(); return 1
function xlsATAN(); return 1

#else

// Funct. cells

function _CELL(); return 1

function _SUM(); return 1
function _MULT(); return 1

// Funct. Math.

function _ABS(); return 1
function _INTE(); return 1
function _MOD(); return 1
function _ROUND(); return 1
function _SIGN(); return 1

function _SQRT(); return 1
function _EXP(); return 1
function _LN(); return 1
function _LOG(); return 1

function _PI(); return 1
function _RANDOM(); return 1

function _SIN(); return 1
function _COS(); return 1
function _TAN(); return 1
function _ASIN(); return 1
function _ACOS(); return 1
function _ATAN(); return 1

#endif
