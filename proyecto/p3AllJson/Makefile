FUENTE = p3
PRUEBA = p3.json

all: compile run

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd -v
	gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -ll -ly

run:
	./$(FUENTE) < $(PRUEBA)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h p3.output

