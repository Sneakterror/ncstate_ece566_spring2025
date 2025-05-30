%{
#include <cstdio>
#include <list>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

using namespace std;

extern FILE *yyin;         // defined in expr.lex
int yylex();               // defined in expr.lex
void yyerror(const char*); // defined in expr.lex

extern "C" {
  // this function is generated by bison from the rules in this file.
  int yyparse();
}

// helper code for string formatting.
template<typename ... Args>
std::string format( const std::string& format, Args ... args )
{
    size_t size = snprintf( nullptr, 0, format.c_str(), args ... ) + 1; // Extra space for '\0'
    if( size <= 0 ){ throw std::runtime_error( "Error during formatting." ); }
    std::unique_ptr<char[]> buf( new char[ size ] ); 
    snprintf( buf.get(), size, format.c_str(), args ... );
    return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
}

int getReg() {
  static int cnt = 8;
  return cnt++;
}

   
%}

// Make the output verbose
%verbose
%define parse.trace


%token <reg> REG IMMEDIATE
%token ASSIGN SEMI PLUS MINUS LPAREN RPAREN LBRACKET RBRACKET
%type <reg> expr
%type  expr

%left  PLUS MINUS

%union {
  int reg;
}

%%

program:
    REG ASSIGN expr SEMI {
        printf("REG (%d) ASSIGN expr SEMI\n", $1);
        return 0;
    }
  ;

expr:
    IMMEDIATE       { printf("IMMEDIATE (%d)\n", $1); $$ = $1; }
  | REG             { printf("REG (%d)\n", $1); $$ = $1; }
  | expr PLUS expr  { printf("expr PLUS expr\n"); $$ = $1 + $3; }
  | expr MINUS expr { printf("expr MINUS expr\n"); $$ = $1 - $3; }
  | LPAREN expr RPAREN { printf("LPAREN expr RPAREN\n"); $$ = $2; }
  | MINUS expr      { printf("MINUS expr\n"); $$ = -$2; }
  | LBRACKET expr RBRACKET { printf("LBRACKET expr RBRACKET\n"); $$ = $2; }
  ;

%%

void yyerror(const char* msg)
{
  printf("%s",msg);
}

int main(int argc, char *argv[]) {
  yydebug = 0;
  yyin = stdin;
  yyparse();
  return 0;
}