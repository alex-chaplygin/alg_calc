typedef struct Symbol { /* элемент таблицы символов */
  char  *name;
  short type; /* VAR, BLTIN, UNDEF */
  union {
    double val;
    /* if VAR */
    double (*ptr)(); /* if BLTIN */
  } u;
  struct Symbol *next; /* чтобы связать с другим */
} Symbol;
Symbol *install(), *lookup();
