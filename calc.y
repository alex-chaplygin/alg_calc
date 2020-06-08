%{
  #include "calc.h"
  extern double Pow();
%}
%union {
  double val;
  /* фактическое значение */
  Symbol *sym; /* указатель на таблицу символов */
}
%token <val> NUMBER
%token <sym> VAR BLTIN UNDEF
%type <val> expr asgn
%right '='
%left '+' '-' /* левоассоциативные, одинаковый приоритет */
%left '*' '/' /* левоассоциативные, более высокий приоритет */
%left UNARYMINUS /* унарный минус */
%right '^'
%%
list:
/* ничего */
| list '\n'
| list asgn '\n'
| list expr '\n' { printf("\t%.8g\n", $2); }
| list error '\n' { yyerrok; }
;
asgn:
VAR '=' expr { $$=$1->u.val=$3; $1->type = VAR; }
;
expr:
NUMBER { $$ = $1; }
| VAR { if ($1->type == UNDEF)
      warning("undefined variable", $1->name);
  $$ = $1->u.val; }
| asgn
| BLTIN '(' expr ')' { $$ = (*($1->u.ptr))($3); }
| '-' expr %prec UNARYMINUS {$$ = -$2; }
| expr '+' expr { $$ = $1 + $3; }
| expr '-' expr { $$ = $1 - $3; }
| expr '*' expr { $$ = $1 * $3; }
| expr '^' expr { $$ = Pow($1, $3); }
| expr '/' expr {
  if ($3 == 0.0)
    warning("division by zero", "");
  else
    $$ = $1 / $3; }
| '(' expr ')' { $$ = $2; }
%%
/* конец грамматики */
#include <stdio.h>
#include <ctype.h>
char
*progname; /* для сообщений об ошибках */
int lineno = 1;
main(int argc, char *argv[])
{
  progname = argv[0];
  init();
  yyparse();
}

yylex()
/* hoc1 */
{
  int c;
  while ((c=getchar()) == ' ' || c == '\t')
    ;
  if (c == EOF)
    return 0;
  if (c == '.' || isdigit(c)) { /* число */
    ungetc(c, stdin);
    scanf("%lf", &yylval);
    return NUMBER;
  }
  if (isalpha(c)) {
    Symbol *s;
    char sbuf[100], *p = sbuf;
    do {
      *p++ = c;
    } while ((c=getchar()) != EOF && isalnum(c));
    ungetc(c, stdin);
    *p = '\0';
    if ((s=lookup(sbuf)) == 0)
      s = install(sbuf, UNDEF, 0.0);
    yylval.sym = s;
    return s->type == UNDEF ? VAR : s->type;
  }
  if (c == '\n')
    lineno++;
  return c;
}

int yyerror(char *s) /* вызывается для обработки синтаксической ошибки yacc */
{
  warning(s, (char *) 0);
}
int warning(char *s, char *t) /* выводит предупреждение */
{
  fprintf(stderr, "%s: %s", progname, s);
  if (t)
    fprintf(stderr, " %s", t);
  fprintf(stderr, " near line %d\n", lineno);
}
