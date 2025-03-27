%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Forward declare scanner & error function
int yylex();
void yyerror(char *s);

// Simple symbol table
typedef struct {
    char name[100];
    int value;
} Symbol;

Symbol symTable[100];
int symCount = 0;

// Look up a symbol by name; return 0 if not found
int getValue(const char* name) {
    for(int i = 0; i < symCount; i++) {
        if(strcmp(symTable[i].name, name) == 0) {
            return symTable[i].value;
        }
    }
    return 0; // default if undeclared
}

// Set symbol's value; if not found, create a new entry
void setValue(const char* name, int val) {
    for(int i = 0; i < symCount; i++) {
        if(strcmp(symTable[i].name, name) == 0) {
            symTable[i].value = val;
            return;
        }
    }
    // Not found, so add it
    strcpy(symTable[symCount].name, name);
    symTable[symCount].value = val;
    symCount++;
}
%}

%union {
    int ival;
    float fval;
    char* sval;
}

// Declare relational operator tokens
%token LT GT

%token <sval> IDENTIFIER
%token <ival> INT_LIT
%token <fval> FLOAT_LIT
%token  INT_KW FLOAT_KW ADD SUB MUL DIV ASSIGN SEMICOLON IF ELSE FOR WHILE LPAREN RPAREN LBRACE RBRACE

%type <ival> expression term factor number

%%

program:
    statements
;

statements:
      statement
    | statements statement
;

statement:
      declaration
    | assignment
    | if_statement
    | while_statement
    | for_statement
;

declaration:
    type IDENTIFIER SEMICOLON {
        printf("Variable declared: %s\n", $2);
    }
;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON {
        setValue($1, $3);
        printf("Assigned to: %s with value: %d\n", $1, $3);
    }
;

if_statement:
    IF LPAREN expression RPAREN LBRACE statements RBRACE {
        printf("If statement executed\n");
    }
;

while_statement:
    WHILE LPAREN expression RPAREN LBRACE statements RBRACE {
        printf("While loop executed\n");
    }
;

for_statement:
    FOR LPAREN assignment expression SEMICOLON assignment RPAREN LBRACE statements RBRACE {
        printf("For loop executed\n");
    }
;

expression:
      term
    | expression ADD term {
        $$ = $1 + $3;
        printf("Result: %d\n", $$);
    }
    | expression SUB term {
        $$ = $1 - $3;
        printf("Result: %d\n", $$);
    }
    // NEW: Compare two expressions
    | expression LT expression {
        $$ = ($1 < $3) ? 1 : 0;
        printf("Relop: %d < %d => %d\n", $1, $3, $$);
    }
    | expression GT expression {
        $$ = ($1 > $3) ? 1 : 0;
        printf("Relop: %d > %d => %d\n", $1, $3, $$);
    }
;

term:
      factor
    | term MUL factor {
        $$ = $1 * $3;
        printf("Result: %d\n", $$);
    }
    | term DIV factor {
        if ($3 == 0) {
            yyerror("Error: Division by zero.");
            exit(1);
        }
        $$ = $1 / $3;
        printf("Result: %d\n", $$);
    }
;

factor:
      IDENTIFIER {
        // Retrieve the variable’s value from the symbol table.
        $$ = getValue($1);
        printf("Using variable: %s => %d\n", $1, $$);
      }
    | number {
        $$ = $1;
      }
    | LPAREN expression RPAREN {
        $$ = $2;
      }
;

number:
      INT_LIT   { $$ = $1; }
    | FLOAT_LIT {
        // If you want to handle floats in calculations properly, you’d adjust the grammar
        // to allow storing a float in $$ (for now, we cast to int).
        $$ = (int)$1;
      }
;

type:
      INT_KW
    | FLOAT_KW
;

%%

int main() {
    printf("Program Start:\n");
    yyparse();
    return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}