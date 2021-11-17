FUENTE = practica1
PRUEBA = proba.txt

all: compile

compile:
	flex $(FUENTE).l
	gcc -o $(FUENTE) lex.yy.c -ll

clean:
	rm $(FUENTE) lex.yy.c 

run:
	./$(FUENTE) < $(PRUEBA)

