X0-Snapshot	:	X0-Lex-Snapshot.l X0-Bison-Snapshot.y
				bison -d -v X0-Bison-Snapshot.y
				flex X0-Lex-Snapshot.l
				cc -o $@ X0-Bison-Snapshot.tab.c lex.yy.c -lfl
		
