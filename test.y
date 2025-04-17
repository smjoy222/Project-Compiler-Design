%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

typedef enum { INT_TYPE, FLOAT_TYPE } VarType;

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

int findSymbol(const char* name) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(symTable[i].name, name) == 0)
            return i;
    }
    return -1;
}

void declareVar(const char* name, VarType type) {
    if (findSymbol(name) != -1) {
        printf("Somossa: Variable '%s' already declare kora hoise.\n", name);
        exit(1);
    }
    strcpy(symTable[symCount].name, name);
    symTable[symCount].type = type;
    symTable[symCount].isSet = 0;
    symCount++;
    printf("Variable declare kora holo: %s\n", name);
}

void setIntValue(const char* name, int val) {
    int idx = findSymbol(name);
    if (idx == -1 || symTable[idx].type != INT_TYPE) {
        printf("somossa: Variable '%s' undeclared othoba mismatch hochhe \n", name);
        exit(1);
    }
    symTable[idx].value.iVal = val;
    symTable[idx].isSet = 1;
    printf("Rakha holo: %s te maan: %d\n", name, val);
}

void setFloatValue(const char* name, float val) {
    int idx = findSymbol(name);
    if (idx == -1 || symTable[idx].type != FLOAT_TYPE) {
        printf("Error: Variable '%s' undeclared or type mismatch\n", name);
        exit(1);
    }
    symTable[idx].value.fVal = val;
    symTable[idx].isSet = 1;
    printf("Rakha holo: %s te maan: %.2f\n", name, val);
}

float getUnifiedValue(const char* name) {
    int idx = findSymbol(name);
    if (idx == -1 || !symTable[idx].isSet) {
        printf("Somossa: Variable '%s' declared set kora hoy ni\n", name);
        exit(1);
    }
    return (symTable[idx].type == FLOAT_TYPE) ? symTable[idx].value.fVal : (float)symTable[idx].value.iVal;
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
%token INT_KW FLOAT_KW ADD SUB MUL DIV ASSIGN SEMICOLON COMMA
%token JODI IF ELSE FOR WHILE SEE LPAREN RPAREN LBRACE RBRACE LT GT JOKHON NOTUBA JONNO DEKHAU

%type <fval> expr
%type <fval> if_statement  

%%

program:
    statements
;

statements:
      statement
    | statements statement
;

statement:
      int_declaration
    | float_declaration
    | assignment
    | see_statement
    | if_statement
    | while_statement
    | for_statement
;

int_declaration:
    INT_KW int_var_list SEMICOLON
;

float_declaration:
    FLOAT_KW float_var_list SEMICOLON
;

int_var_list:
      IDENTIFIER { declareVar($1, INT_TYPE); }
    | int_var_list COMMA IDENTIFIER { declareVar($3, INT_TYPE); }
;

float_var_list:
      IDENTIFIER { declareVar($1, FLOAT_TYPE); }
    | float_var_list COMMA IDENTIFIER { declareVar($3, FLOAT_TYPE); }
;

assignment:
    IDENTIFIER ASSIGN expr SEMICOLON {
        int idx = findSymbol($1);
        if (idx == -1) {
            printf("somossa: Variable '%s' declared kora hoy ni\n", $1);
            exit(1);
        }
        if (symTable[idx].type == INT_TYPE)
            setIntValue($1, (int)$3);
        else
            setFloatValue($1, $3);
    }
;

see_statement:
    DEKHAU IDENTIFIER SEMICOLON {
        int idx = findSymbol($2);
        if (idx == -1 || !symTable[idx].isSet) {
            printf("somossa: Variable '%s' declared initialized kora hoy ni\n", $2);
            exit(1);
        }
        if (symTable[idx].type == INT_TYPE)
            printf("Dekhano Hocche: %s = %d\n", $2, symTable[idx].value.iVal);
        else
            printf("Dekhano Hocche: %s = %.2f\n", $2, symTable[idx].value.fVal);
    }
;

if_statement:
    JODI LPAREN expr RPAREN LBRACE statements RBRACE NOTUBA LBRACE statements RBRACE {
        if ($3 != 0.0) {  
            printf("Jodi-(if) executed (condition shotto)\n");
            $$ = 1.0; 
            
        } else {
            printf("Jodi-(If) skipped (condition mittha)\n");
            $$ = 0.0;  
            
        }
    }
;



while_statement:
    WHILE LPAREN expr RPAREN LBRACE statements RBRACE {
        if ($3 != 0.0) {
            printf("jokhon loop executed (condition true)\n");
        } else {
            printf("jokhon loop not executed (condition false)\n");
        }
    }
;

for_statement:
    JONNO LPAREN assignment expr SEMICOLON assignment RPAREN LBRACE statements RBRACE {
        printf("For executed\n");
    }
;

expr:
      INT_LIT { $$ = (float)$1; }
    | FLOAT_LIT { $$ = $1; }
    | IDENTIFIER { $$ = getUnifiedValue($1); }
    | expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr {
        if($3 == 0.0) { yyerror("zero diye vagh kora jabe na"); exit(1); }
        $$ = $1 / $3;
      }
    | expr GT expr { $$ = ($1 > $3) ? 1.0 : 0.0; }
    | expr LT expr { $$ = ($1 < $3) ? 1.0 : 0.0; }
;

%%

int main(void) {
    printf("suru hochhe program:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
