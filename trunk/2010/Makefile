all:
	lex submain.l && gcc lex.yy.c -lfl -o pre
	lex main.l && gcc lex.yy.c Grammar.c LinkedList.c String.c -lfl -o post
	gcc parser.c -o parser
clear:
	rm pre post parser

