
%{
#include <stdio.h>

int yylex();
 
extern FILE *yyin;
int yyerror(char *msg);
 
%}

%union {
  int val;
}

%token HYPHEN ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE ZERO
%token TWENTY THIRTY FORTY FIFTY SIXTY SEVENTY EIGHTY NINETY
%token HUNDRED
%token TEN ELEVEN TWELVE THIRTEEN FOURTEEN FIFTEEN SIXTEEN SEVENTEEN EIGHTEEN NINETEEN
%token NEWLINE

%type <val> expr tens ones or

%%


expr_list :   expr NEWLINE           { printf("=%d\n", $1); }
            | expr_list expr NEWLINE { printf("=%d\n", $2); }
;


expr: tens or { $$ = $1 + $2; }
   | ones { $$ = $1; }
   | ZERO { $$ = 0; }
;

or: HYPHEN ones { $$ = $2; }
| { $$ = 0; };

 tens: TWENTY { $$ = 20; }
| THIRTY
| FORTY
| FIFTY
| SIXTY
| SEVENTY
| EIGHTY
| NINETY
;

 ones: ONE { $$ = 1; }
| TWO { $$ = 2; }
| THREE { $$ = 3; }
| FOUR { $$ = 4; }
   | FIVE { $$ = 5 ;}
   | SIX { $$ = 6; }
   | SEVEN { $$ = 7; }
   | EIGHT { $$ = 8; }
   | NINE { $$ = 9; }
;

%%

int yywrap() { return 0; }

int yyerror(char *msg) {
  printf("%s",msg);
  return 0;
}

int main()
{
  yyin = stdin;

  yyparse();

  return 0;
}
