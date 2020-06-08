#include "calc.h"
#include "y.tab.h"
static Symbol *symlist = 0; /* таблица символов: связанный список */
Symbol *lookup(s)
     char *s;
{
  Symbol *sp;
  /* поиск s в таблице символов */
  for (sp = symlist; sp != (Symbol *) 0; sp = sp->next)
    if (strcmp(sp->name, s) == 0)
      return sp;
  return 0; /* 0 ==> не найдено */
}

Symbol *install(s, t, d) /* внести s в таблицу символов */
     char *s;
     int t;
     double d;
{
  Symbol *sp;
  char *emalloc();
  sp = (Symbol *) emalloc(sizeof(Symbol));
  sp->name = emalloc(strlen(s)+1); /* +1 для '\0' */
  strcpy(sp->name, s);
  sp->type = t;
  sp->u.val = d;
  sp->next = symlist; /* поместить в начало списка */
  symlist = sp;
  return sp;
}

char *emalloc(n)
/* проверить значение, возвращенное malloc */
     unsigned n;
{
  char *p, *malloc();
  p = malloc(n);
  if (p == 0)
    warning("out of memory", (char *) 0);
  return p;
}
