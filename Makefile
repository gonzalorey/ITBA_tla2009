#Makefile del tp de TLA 20
#Autores
# Augusto Nizzo Mc Intosh 47443
# Marcos Damían Pianelli 47360
# Pablo Sebastían Muiña 47356

CC = gcc
LEX = flex
CFLAGS = -c -g
LDFLAGS = -lfl

#Directorios
INC_PATH = include/
SRC_PATH = src/

#Destion
EXEC = pwiki


all:
	$(LEX) $(SRC_PATH)main.l
	$(CC) $(CFLAGS) $(SRC_PATH)*.c *.c -I $(INC_PATH)
	$(CC) *.o $(LDFLAGS) -o $(EXEC) 
	rm *.o
	rm lex.yy.c
clean:
	rm $(EXEC)
