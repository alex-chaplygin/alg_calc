%{
#define YYSTYPE double /* тип данных для стека yacc */
%}
%token NUMBER
%left '+' '-' /* левоассоциативные, одинаковый приоритет */
%left '*' '/' /* левоассоциативные, более высокий приоритет */
%left UNARYMINUS /* унарный минус */
%%
list:
/* ничего */
| list '\n'
| list expr '\n'
{ printf("\t%.8g\n", $2); }
;
expr:
NUMBER
{ $$ = $1; }
| '-' expr %prec UNARYMINUS {$$ = -$2; }
| expr '+' expr { $$ = $1 + $3; }
| expr '-' expr { $$ = $1 - $3; }
| expr '*' expr { $$ = $1 * $3; }
| expr '/' expr { $$ = $1 / $3; }
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
