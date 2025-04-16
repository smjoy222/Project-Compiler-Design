%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char *s);

// Symbol table structure now includes a flag to indicate declaration.
typedef struct {
    char name[100];
    int value;
    int declared;  // 1 if declared, 0 otherwise
} Symbol;

Symbol symTable[100];
int symCount = 0;

// Returns index of the variable if found; otherwise returns -1.
int getIndex(const char* name) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(symTable[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

// Retrieves the value of a declared variable.
int getValue(const char* name) {
    int idx = getIndex(name);
    if (idx != -1 && symTable[idx].declared) {
        return symTable[idx].value;
    } else {
        yyerror("Variable used without declaration");
        exit(1);
    }
}

// Sets the value for a declared variable.
void setValue(const char* name, int val) {
    int idx = getIndex(name);
    if (idx != -1 && symTable[idx].declared) {
        symTable[idx].value = val;
    } else {
        yyerror("Variable assigned without declaration");
        exit(1);
    }
}

// Declares a new variable. If the variable already exists, it reports an error.
void declareVariable(const char* name) {
    if (getIndex(name) == -1) {
        strcpy(symTable[symCount].name, name);
        symTable[symCount].declared = 1;
        symTable[symCount].value = 0;  // Default initial value.
        symCount++;
    } else {
        yyerror("Variable redeclared");
        exit(1);
    }
}
%}

%union {
    int ival;
    float fval;
    char* sval;
}

%token <sval> IDENTIFIER
%token <ival> INT_LIT
%token <fval> FLOAT_LIT
%token INT_KW FLOAT_KW ADD SUB MUL DIV ASSIGN SEMICOLON IF ELSE FOR WHILE LPAREN RPAREN LBRACE RBRACE SEE COMMA
%token LT GT

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
    | see_statement
;

declaration:
    type id_list SEMICOLON
;

id_list:
      IDENTIFIER { 
          declareVariable($1);
          printf("Variable declared: %s\n", $1);
      }
    | id_list COMMA IDENTIFIER {
          declareVariable($3);
          printf("Variable declared: %s\n", $3);
      }
;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON {
        setValue($1, $3);
        printf("Assigned to: %s with value: %d\n", $1, $3);
    }
;

see_statement:
    SEE IDENTIFIER SEMICOLON {
        printf("See statement executed: %s = %d\n", $2, getValue($2));
    }
;

if_statement:
    IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE {
        if ($3) {
            printf("\na is less than b\nif statement executed (jodi block)\n");
        } else {
            printf("\na is NOT less than b\nelse statement executed (notuba block)\n");
        }
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
    | expression ADD term { $$ = $1 + $3; }
    | expression SUB term { $$ = $1 - $3; }
    | expression LT expression { $$ = ($1 < $3) ? 1 : 0; }
    | expression GT expression { $$ = ($1 > $3) ? 1 : 0; }
;

term:
      factor
    | term MUL factor { $$ = $1 * $3; }
    | term DIV factor {
        if ($3 == 0) {
            yyerror("Error: Division by zero.");
            exit(1);
        }
        $$ = $1 / $3;
    }
;

factor:
      IDENTIFIER { $$ = getValue($1); }
    | number     { $$ = $1; }
    | LPAREN expression RPAREN { $$ = $2; }
;

number:
      INT_LIT   { $$ = $1; }
    | FLOAT_LIT { $$ = (int)$1; }
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
