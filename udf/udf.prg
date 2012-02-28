PROCEDURE Main()


CLEAR SCREEN

? "http://redmine.bring.out.ba/issues/26870, hb_howto_manual.pdf"
?

? "Result udf=", udf()
? "Result multiply 2 x 3 =", multiply(2, 3)
  
RETURN

#pragma BEGINDUMP

#include <hbapi.h>


HB_FUNC(UDF) {
  
unsigned int a, b, c;

a = 16;
b = 5;

c = a + b;

hb_retni(c);

}


HB_FUNC(MULTIPLY) {
  
unsigned int a,b,c;
   
a = hb_parni(1);
b = hb_parni(2);
   
c = a * b;

hb_retni(c);

}

#pragma ENDDUMP
