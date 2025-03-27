all:
	bison -d test.y
	flex test.l
	gcc -o testex test.tab.c lex.yy.c
	./testex
