#include "calc.h"
#include "y.tab.h"
#include <math.h>
extern double
Log(), Log10(), Exp(), Sqrt(), integer();
static struct {
  /* Константы */
  char
  *name;
  double cval;
} consts[] = {
  "PI",3.14159265358979323846,
  "E",2.71828182845904523536,
  "GAMMA", 0.57721566490153286060, /* постоянная Эйлера */
  "DEG", 57.29577951308232087680, /* градусов/радиан */
  "PHI", 1.61803398874989484820, /* золотое отношение */
  0, 0
};
static struct {/*Встроенные функции */

  char
  *name;
  double (*func)();
} builtins[] = {
  "sin", sin,
  "cos", cos,
  "atan", atan,
  "log", Log,

  "log10", Log10, 
  "exp", Exp,

  "sqrt", Sqrt, 
  "int", integer,
  "abs", fabs,
  0, 0
};


init() /* вставить константы и встроенные функции в таблицу */
{
  int i;
  Symbol *s;
  for (i = 0; consts[i].name; i++)
    install(consts[i].name, VAR, consts[i].cval);
  for (i = 0; builtins[i].name; i++) {
    s = install(builtins[i].name, BLTIN, 0.0);
    s->u.ptr = builtins[i].func;
  }
}
