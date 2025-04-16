/* parser.y */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char *s);

/* Define variable types */
typedef enum { INT_TYPE, FLOAT_TYPE } VarType;

/* Symbol structure: stores name, type, value, and an isSet flag */
typedef struct {
    char name[100];
    VarType type;
    union {
        int iVal;
        float fVal;
    } value;
    int isSet;
} Symbol;

Symbol symTable[100];
int symCount = 0;

/* Look up a symbol by name; returns its index or -1 if not found */
int findSymbol(const char* name) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(symTable[i].name, name) == 0)
            return i;
    }
    return -1;
}

/* Declare a variable with a given type */
void declareVar(const char* name, VarType type) {
    if (findSymbol(name) != -1) {
        printf("Error: Variable '%s' already declared.\n", name);
        exit(1);
    }
    strcpy(symTable[symCount].name, name);
    symTable[symCount].type = type;
    symTable[symCount].isSet = 0;
    symCount++;
    printf("Variable declared: %s\n", name);
}

/* Assignment for int variables: the expression is computed as float and then converted */
void setIntValue(const char* name, float val) {
    int idx = findSymbol(name);
    if (idx == -1 || symTable[idx].type != INT_TYPE) {
        printf("Error: Variable '%s' undeclared or type mismatch\n", name);
        exit(1);
    }
    symTable[idx].value.iVal = (int)val;
    symTable[idx].isSet = 1;
    printf("Assigned to: %s with value: %d\n", name, (int)val);
}

/* Assignment for float variables */
void setFloatValue(const char* name, float val) {
    int idx = findSymbol(name);
    if (idx == -1 || symTable[idx].type != FLOAT_TYPE) {
        printf("Error: Variable '%s' undeclared or type mismatch\n", name);
        exit(1);
    }
    symTable[idx].value.fVal = val;
    symTable[idx].isSet = 1;
    printf("Assigned to: %s with value: %.2f\n", name, val);
}

/* Unified getter: returns a float value for a variable regardless of its type.
   If the variable is int, it is promoted to float. */
float getUnifiedValue(const char* name) {
    int idx = findSymbol(name);
    if (idx == -1 || !symTable[idx].isSet) {
        printf("Error: Variable '%s' undeclared or not set\n", name);
        exit(1);
    }
    if (symTable[idx].type == FLOAT_TYPE)
        return symTable[idx].value.fVal;
    else
        return (float)symTable[idx].value.iVal;
}
%}

/* Define the semantic value union */
%union {
    int ival;
    float fval;
    char* sval;
}

/* Token declarations along with associated types */
%token <sval> IDENTIFIER
%token <ival> INT_LIT
%token <fval> FLOAT_LIT
%token INT_KW FLOAT_KW ADD SUB MUL DIV ASSIGN SEMICOLON COMMA
%token IF ELSE FOR WHILE SEE LPAREN RPAREN LBRACE RBRACE LT GT

/* The nonterminal 'expr' always returns a float value */
%type <fval> expr

%%

/* Grammar Rules */

/* The top-level program is a list of statements */
program:
      statements
    ;

/* Zero or more statements */
statements:
      /* empty */
    | statements statement
    ;

/* A statement can be a declaration, assignment, see or control statement */
statement:
      int_declaration
    | float_declaration
    | assignment
    | see_statement
    | if_statement
    | while_statement
    | for_statement
    ;

/* Declaration rules for integer variables */
int_declaration:
    INT_KW int_var_list SEMICOLON
    ;

/* Declaration rules for float variables */
float_declaration:
    FLOAT_KW float_var_list SEMICOLON
    ;

/* List of identifiers for int declaration */
int_var_list:
      IDENTIFIER { declareVar($1, INT_TYPE); }
    | int_var_list COMMA IDENTIFIER { declareVar($3, INT_TYPE); }
    ;

/* List of identifiers for float declaration */
float_var_list:
      IDENTIFIER { declareVar($1, FLOAT_TYPE); }
    | float_var_list COMMA IDENTIFIER { declareVar($3, FLOAT_TYPE); }
    ;

/* Assignment: evaluates an expression and assigns it to a variable.
   The expression is always computed as a float. */
assignment:
    IDENTIFIER ASSIGN expr SEMICOLON {
         int idx = findSymbol($1);
         if (idx == -1) {
             printf("Error: Variable '%s' undeclared\n", $1);
             exit(1);
         }
         if (symTable[idx].type == INT_TYPE)
             setIntValue($1, $3);
         else
             setFloatValue($1, $3);
    }
    ;

/* See statement: prints the current value of a variable based on its type */
see_statement:
    SEE IDENTIFIER SEMICOLON {
         int idx = findSymbol($2);
         if (idx == -1) {
             printf("Error: Variable '%s' undeclared\n", $2);
             exit(1);
         }
         if (symTable[idx].type == INT_TYPE)
             printf("See statement executed: %s = %d\n", $2, symTable[idx].value.iVal);
         else
             printf("See statement executed: %s = %.2f\n", $2, symTable[idx].value.fVal);
    }
    ;

/* If statement: evaluates an expression for the condition and executes the block of statements */
if_statement:
    IF LPAREN expr RPAREN LBRACE statements RBRACE {
         if ($3)
             printf("If statement executed: condition true\n");
         else
             printf("If statement executed: condition false\n");
    }
    ;

/* While statement: executes the block repeatedly while the condition evaluates to true.
   (For simplicity, this parser only prints a message instead of looping execution.) */
while_statement:
    WHILE LPAREN expr RPAREN LBRACE statements RBRACE {
         printf("While loop executed (simulation)\n");
    }
    ;

/* For statement: includes an initialization assignment, condition, and a second assignment.
   Again, it only prints a message as a simulation. */
for_statement:
    FOR LPAREN assignment expr SEMICOLON assignment RPAREN LBRACE statements RBRACE {
         printf("For loop executed (simulation)\n");
    }
    ;

/* The expression rules support int and float literals, identifiers, and arithmetic.
   All arithmetic is performed in float. */
expr:
      INT_LIT   { $$ = (float)$1; }
    | FLOAT_LIT { $$ = $1; }
    | IDENTIFIER { $$ = getUnifiedValue($1); }
    | expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr { 
         if($3 == 0.0) { 
             yyerror("Division by zero"); 
             exit(1); 
         } else { 
             $$ = $1 / $3; 
         }
      }
    ;

%%

int main(void) {
    printf("Program Start:\n");
    yyparse();
    return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
