%{
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <string.h>
#include <math.h>

#define bool 			int
#define true 			1
#define false 			0

#define SYM_TABLE 		200				// Max Capicity of symbol table
#define ID_NAME_LEN		20				// Max length of ident
#define ADDRESS_MAX		8000			// Upper bound of the address
#define DEPTH_MAX		10				// Max depth of declaration, Un used
#define CODE_MAX		1000			// Max Virtual Machine code amount
#define STACK_SIZE		8000			// Max Run-Time stack element amount
#define STRING_LEN		201				// Max length of const string
#define ERROR_MAG_NUM	1145141919810	// For error processing
#define MAX_ARR_DIM		10				// Max dimension of the array
#define FLOAT_EPS		0.001			// Using for float opran comparing
#define MAX_CASE_NUM	100				// Max case in switch statement

typedef unsigned char byte;
int cnt = 0;
enum object {
	constant_int,
	constant_real,
	constant_bool,
	constant_string,
	constant_char,
	variable_int,
	variable_real,
	variable_bool,
	variable_string,
	variable_char,
	constant_int_array,
	variable_int_array,
	constant_real_array,
	variable_real_array,
	constant_char_array,
	variable_char_array,
	constant_bool_array,
	variable_bool_array,
	constant_string_array,
	variable_string_array,
	function,
};

struct symbol_table {
	char 	name[ID_NAME_LEN];
	enum 	object kind;
	int 	addr;
	byte 	val[STRING_LEN];			// Use byte to store all kind of data, use pointer to specify them
	int		init_or_not;
	int		array_size;
	int 	array_const_or_not;
	int 	array_dim[MAX_ARR_DIM];
//	void*	val;						// Using pointer to specify unlimitted length constant string @todo: in the future.
};

struct symbol_table table[SYM_TABLE];	// Store all symbol

enum data_type {
	integer,		real,
	single_char,	boolean,
	str,
};

struct data_stack {
	enum 	data_type t;				// current un-used
	byte 	val[STRING_LEN];
};

enum fct {
	lit,	opr,	lod,
	sto,	cal,	ini,
	jmp,	jpc,	off,
};

struct instruction {
	enum 	fct f;
	int 	lev;						// Used for type identifying
										// For all ato lod opr, this should be use to specify type
										// 2 for integer
										// 3 for real
										// 4 for string
										// 5 for bool
										// 6 for char
	byte	opr[STRING_LEN];
};

struct instruction code[CODE_MAX];		// Store V-Machine code

int			sym_tab_tail;							// tail of sym table
int			vm_code_pointer = 0;					// pc during parsing stage
char		id_name[ID_NAME_LEN];					// current parsing ident name
int			outter_int;								// used for temp result
float		outter_real;							// Un-used
bool		outter_bool;							// Un-used
char		outter_char;							// Un-used
char		outter_string[STRING_LEN];				// Un-used
int			err_num;								// Un-used
int			constant_decl_or_not = 0;
int 		var_decl_with_init_or_not = 0;
int			cur_decl_type = -1;
char		curr_read_write_ident[ID_NAME_LEN];
int 		curr_address = 3;						// RA,SL,DL for future function module
int 		inbuf_int;								// for read() [opr $% 20]
float		inbuf_real;								// for read() [opr $% 20]
char		inbuf_char;								// for read() [opr $% 20]
char		inbuf_string[STRING_LEN];				// for read() [opr $% 20]
char		inbuf_bool[6];							// for read() [opr $% 20]
int			bool_flag;
int			arr_size = 0;
int			tmp_arr_list[MAX_ARR_DIM];
int			tmp_arr_dim_idx = 0;
struct 		data_stack s[STACK_SIZE];
int 		stack_top = 2;
int 		array_offset;
int 		tmp_arr_cur_dim;
int 		glob_var_addr;
int			back_patch_list[STRING_LEN];
int			back_patch_idx = 0;
int 		curr_ident_array_or_not = 0;
int			else_compound;
int			do_start_idx;
int			break_return_address_by_level[DEPTH_MAX];			// Using to recording return address of for, while, do, switch per level to back patch the break statement
int			continue_return_address_by_level[DEPTH_MAX];
int			cur_break_level = 0;
int			cur_continue_level = 0;
int			break_statement_address[DEPTH_MAX][STRING_LEN];
int			continue_statement_address[DEPTH_MAX][STRING_LEN];	// Allowed up to 200 continue and break.
int			cur_level = 0;
int			inc_flag;											// inc++ inc-- act differently when pop stack top

struct expression_result {
	enum	data_type	t;
	int		res_int;
	float	res_real;
	bool	res_bool;
	char	res_char;
	char	res_string[STRING_LEN];
};

struct expression_result e_res;

struct bp_list {
	int 	case_start;
	int 	case_end;
};

FILE*		fin;
FILE*		ftable;
FILE*		fcode;
FILE*		foutput;
FILE*		fresult;
char		fname;
int 		err;
extern int	line;

void 		init();
void		enter(enum object k);
void 		gen(enum fct x, int y, byte* z);

%}

%union {
	char 	*ident;
	int 	number;
	char 	*text;
	char 	single_char;
	int 	flag;
	double 	realnumber;
	struct 	bp_list *bp;
}

%token BOOLSYM BREAKSYM CALLSYM CASESYM CHARSYM COLON CONSTSYM CONTINUESYM DEFAULTSYM DOSYM ELSESYM
%token ELSESYM EXITSYM FORSYM INTSYM IFSYM MAINSYM READSYM REALSYM REPEATSYM RR RL LPAREN RPAREN
%token STRINGSYM SWITCHSYM UNTILSYM WHILESYM WRITESYM LBRACE RBRACE LBRACKET RBRACKET BITAND BITOR
%token BECOMES COMMA LSS LEQ GTR GEQ EQL NEQ PLUS INCPLUS MINUS INCMINUS TIMES DEVIDE
%token LPAREN RPAREN MOD SEMICOLON XOR AND OR NOT YAJU YARIMASUNESYM KIBONOHANASYM RETURNSYM

%token <ident> 			IDENT
%token <number> 		INTEGER
%token <text>			STRING
%token <single_char>	CHAR
%token <flag>			BOOL
%token <realnumber>		REAL

%type <number>			factor term additive_expr								// Indicate type of factor
%type <number>			expression var INC_OR_NOT								// Indicate type of expression
%type <number>			identlist identarraylist identdef
%type <number>			simple_expr SINGLEOPR SEMICOLON SEMICOLONSTAT LPARENSTAT LPAREN RPAREN RPARENSTAT
%type <number>			dimension dimensionlist PLUSMINUS TIMESDEVIDE ELSESYMSTAT WHILESYMSTAT
%type <number>			expression_list OPR CASESYM DEFAULTSYM 					// This Expression only for ARRAY LOCATING!!!!!!!!
%type <number>			statement statement_list compound_statement while_statement for_statement do_statement program if_statement else_list
%type <bp>				case_stat default_statement								// For case back patch, problem in naked switch parsing, change to compound
%%

program: 				function_decl
						MAINSYM 
						LBRACE {
							
						}
						statement_list {
						
						}
						RBRACE 
						;
		
declaration_list:		declaration_list declaration_stat 
					  | declaration_stat 
					  | 
						;

declaration_stat:		typeenum identlist SEMICOLONSTAT { /* Why can't me add sth after typeenum?? */ }
					  | typeenum identarraylist { 
						  	
						} SEMICOLON
					  | CONSTSYM typeenum { 

						} identlist { 

						} SEMICOLON
					  | CONSTSYM typeenum { 
					  
						} identarraylist { 

						} SEMICOLON;
						;

identlist:				identdef 
					  |	identlist COMMA identdef
					  	;

identdef:				IDENT {
							
	 					}
					  |	IDENT BECOMES factor {
						  	
					  	}
						;

typeenum:				INTSYM 		{  }
					  | STRINGSYM 	{  }
					  | BOOLSYM 	{  }
					  | REALSYM 	{  }
					  | CHARSYM		{  }
						;

identarraylist:			identarraydef
					  |	identarraylist COMMA identarraydef
						;
				
identarraydef:			IDENT LBRACKET dimensionlist RBRACKET {
							
						}
						;

dimensionlist:			dimension {
							
						}
					  | dimensionlist COMMA dimension {
						  
					  	}
					  	;

dimension:				INTEGER {
							
						}
						;

statement_list:			statement_list statement
					  | statement 
					  |
						;
						
statement:				expression_statement 
					  | if_statement 	
					  | while_statement 	
					  | read_statement 	
					  | write_statement 
					  | compound_statement 	
					  | for_statement 	
					  | do_statement 			
					  | declaration_list 	
					  | continue_stat 			
					  | break_stat 				
					  | switch_statement 
					  | case_list
					  | yarimasu_stat
					  |
						;

switch_statement:		SWITCHSYM LPARENSTAT expression RPARENSTAT LBRACE case_list default_statement RBRACE {
							
						}
						;

case_list:				case_list case_stat {
						  	
						}
					  |	case_stat {

					  	}
					  |
						;

case_stat:				CASESYM expression COLON {
							
						} compound_statement {
							
						}
					  | 
						;

default_statement:		DEFAULTSYM COLON compound_statement {
							
						}
						;
						
continue_stat:			CONTINUESYM SEMICOLONSTAT {
							
						}
						;
						
break_stat:				BREAKSYM SEMICOLONSTAT {
							
						}
						;
						
if_statement:		  	IFSYM LPARENSTAT expression RPARENSTAT { //// @todo: Causion: if ++ -- in expression, should pop a result from the data stack, not the problem of ++ -- 
							
						} compound_statement {
							
					  	} else_list {
							
						}
						;

else_list:				ELSESYMSTAT { 
							
						} compound_statement { 
							
						}
					  |	{ 
					  
						}
						;

ELSESYMSTAT:			ELSESYM { 

						}
						;

while_statement:		WHILESYMSTAT LPARENSTAT expression RPARENSTAT { // @todo: Causion: if ++ -- in expression, should pop a result from the data stack, not the problem of ++ -- 
							
						} compound_statement {
							
						}
						;
WHILESYMSTAT:			WHILESYM {

						}
						;
	
write_statement:		WRITESYM LPARENSTAT expression RPARENSTAT SEMICOLONSTAT {
							
						}
						;
	
read_statement:			READSYM LPARENSTAT var RPARENSTAT SEMICOLONSTAT {
							
						}
						;
						
compound_statement:		LBRACE {		// Please re-construct here, put gen(jpc/jmp) out of the compound statements
							
						} statement_list RBRACE {
							
						}
						;
						
for_statement:			FORSYM LPARENSTAT 
						expression SEMICOLONSTAT {				// e1
							
						}
						expression SEMICOLONSTAT {				// e2
							
						}			
						expression RPARENSTAT INC_OR_NOT {		// e3
							
						}
						compound_statement {
							
						}
						;
						
INC_OR_NOT:				
						;

do_statement:			DOSYM { 
							
						} compound_statement WHILESYM LPAREN expression RPARENSTAT {
							
						} SEMICOLONSTAT
						;
	
var:					IDENT {
							
						}
					  | IDENT LBRACKET expression_list RBRACKET {
						  	
					  	}
						;

expression_list:		expression {
							
						}
					  | expression_list COMMA expression {
						  	
					  	}
						;

expression_statement:	expression SEMICOLONSTAT {
							
						} 
					  | SEMICOLONSTAT
						;

expression:				var {
							
						} 
						BECOMES expression {
							
						}
					  | simple_expr {
						  	;
					  	}
					  | {

						}
						;

simple_expr:			additive_expr { 

						}
					  | additive_expr OPR additive_expr { 
						  	
						}
					  | additive_expr SINGLEOPR { 
						  	
						}
					  | SINGLEOPR additive_expr { 
						  	
						}
						;

SINGLEOPR:				INCPLUS {
							
						}
					  | INCMINUS {
						  	
					  	}
					  | NOT {
						  	
					  	}
						;

OPR:					EQL {
							
						}
					  | NEQ {
						  	
					  	}
					  | LSS {
						  	
					  	}
					  | LEQ {
						  	
					  	}
					  | GTR {
						  
					  	}
					  | GEQ {
						  	
					  	}
					  | AND {
						  	
					  	}
					  | OR {
						  	
					 	}
					  | XOR {
						  	
					 	}
					  | BITAND {
						  	
					  	}
					  | BITOR {
						  	
					  	}
					  | RR {
						  	
					  	}
					  | RL {
						  
					  	}
						;

additive_expr:			term {
							
						}
					  | additive_expr PLUSMINUS term {
							
					  	}
						;

PLUSMINUS:				PLUS {
							
						}
					  | MINUS {
						  	
					 	}
						;

term:					factor {
							
						}
					  | term TIMESDEVIDE factor {
							
					  	}
						;

TIMESDEVIDE:			TIMES {
							
						}
					  | DEVIDE {
						  	
					  	}
					  | MOD {
						  	
					  	}
						;

factor:					LPARENSTAT expression RPARENSTAT {
							
						}
					  | var {
						  	
					  	}
					  | INTEGER {
						  	
					  	}
					  | REAL {
						  	
					  	}
					  | STRING {
						  	
					  	}
					  | BOOL {
						  	
					  	}
					  | CHAR {
						  	
					  	}
					  | YAJU {
						  	
					  	}
						;

SEMICOLONSTAT:			SEMICOLON {

						}
						;
				
LPARENSTAT:				LPAREN {

						}
						;

RPARENSTAT:				RPAREN {

						}
						;
function_decl_list:		function_decl_list function_decl
					  | function_decl
						;

function_decl:			typeenum IDENT LPAREN para_list RPAREN compound_statement
					  | 
						;

para_list:				para_list COMMA para_item
					  | para_item
					  	;

para_item:				typeenum IDENT 
					  |
					  	;

yarimasu_stat:			YARIMASUNESYM SEMICOLON {
							int opran = 1;
							printf("              ,O@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO/`.\n	\
                 \\@OOOOOOOOOOOOOOOOOOOOOOOOO@@@@OOOOOOO/..=\n	\
                   [@@OOOOOOOOO@@OOO`........[OO@@@@\\`     \n	\
                     ,\\[`.,O@@OO[`*.......*....,OO@@@@@@@@^\n	\
                        ,OOO[**=OO\\`*..**********=OO@@@@@@^\n	\
                    .],**********O@O^**************\\OO@@@@@\n	\
                  /o/**....****o,O@Oo**************,oOO@@@@\n	\
               ,OO/`*........**,oOOOO\\**************\\OOO@@@\n	\
             ]Oo[****.....]]]****,/\\[******.*****,]]ooOO@@@\n	\
          ./o[***********,oOO^..*,]ooOOOOo`****ooooooooOO@@\n	\
         ,o[**.***]]\\o\\oooOOO\\**/OOOOOOOOOOoooooooooooOOO@@\n\
       	       .//****,oOOOOO@OOo\\ooOO@OOOOoooooOOO@OOoooOOooOOOOO@\n	\
      ,O/**=OOOoOO@@]  \\OOoooO@OOOo.***,\\*.,\\OOOOOooooOOOO@\n\
     	     ,OO^**=oOO\\,*,@@@` ,OOOOOOOOO*.*****=oooOOOOOoooOOOO@@\n	\
   ,O@OOooooooOOOo..O@@^ ,OOOOo`*....****/oOOoOOOOOOOOOO@@@\n	\
 ,OOOOOOOOOoo//OOOOOooO@@OOOOO`*....***/ooOOOOOOOOOOOO@@@@@\n	\
OOoOOOOOOOOOOooooOOOOOOOOOOOo`*.***]/ooooooOoooooOOO@@@@@@@\n	\
oooOOOOOOOOOOOOoooOOOOooooo^****/ooooooooooooooOOO@@@@@@@@@\n	\
oooOOOOOOOOOOOOOooooOooo^*,*/ooooooooooooooooOOOO@@@@@@@@@@\n	\
ooOOOOO@@OOOOOOOOooooooooooooooooooooooooooOOO@@@@@@@@@@@@@\n	\
oOOOOOO@@@@OOOOOOOoooooooooooooooooooooooOOOO@@@@@@@@@@@O[.\n	\
oooooooO@@@@@@OOOOOOOooooooooooooooOOOOOOOOOOOO@@@@@@@O`.  \n	\
ooooooooOO@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOooO@@@/`.     \n	\
ooooooooooOOOO@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOO@@O`..        \n");
							gen(jmp, 0, (byte*)opran);
						}
						;	
%%

void init() {
	sym_tab_tail 		= 0;
	vm_code_pointer 	= 0 ;
	outter_int 			= 0;
	outter_real 		= 0.0;
	outter_char 		= 0;
	outter_bool 		= false;
	err_num				= 0;
	strcpy(outter_string, "\0");
}

int yyerror(char *s) {
	err_num++;
	printf("%s in line %d.\n", s, line);
	fprintf(foutput, "%s in line %d.\n", s, line);
	return 0;
}

void gen(enum fct x, int y, byte z[STRING_LEN]) {

	vm_code_pointer++;
}

void enter(enum object k) {
	sym_tab_tail++;
	strcpy(table[sym_tab_tail].name, id_name);
	table[sym_tab_tail].kind = k;
	table[sym_tab_tail].init_or_not = 0;
	switch (k) {
		case constant_int:
			break;
		case constant_real:
			break;
		case constant_string:
			break;
		case constant_char:
			break;
		case constant_bool:
			break;
		case variable_int:
			break;
		case variable_real:
			break;
		case variable_string:
			break;
		case variable_char:
			break;
		case variable_bool:
			break;
		case constant_int_array:
		case constant_real_array:
		case constant_bool_array:
		case constant_char_array:
		case constant_string_array:
		
		case variable_int_array:
		case variable_real_array:
		case variable_bool_array:
		case variable_char_array:
		case variable_string_array:
			break;
	}
}

void display_sym_tab() {			// @todo: Finish sym-table displaying
	int i, j;
	for (i = 1; i <= sym_tab_tail; i++) {
		switch (table[i].kind) {
			case constant_int:
				break;
			case constant_real:
				break;
			case constant_char:
				break;
			case constant_string:
				break;
			case constant_bool:
				break;
			case variable_int:
				break;
			case variable_real:
				break;
			case variable_char:
				break;
			case variable_string:
				break;
			case variable_bool:
				break;
			case constant_int_array:
			case constant_real_array:
			case constant_bool_array:
			case constant_char_array:
			case constant_string_array:
				break;
			case variable_int_array:
			case variable_real_array:
			case variable_bool_array:
			case variable_char_array:
			case variable_string_array:
				break;
		}
	}
}

int find_addr_of_ident(char *s) {
}

void interpret() {
	// Unknown error of unexpected output!
	int 		pc = 0;
	int 		base = 1;
	struct 		instruction i;
	int			iter;
	int			jter;
	memset(inbuf_string, 0, sizeof inbuf_string);
	printf("Start X0\n");
	fprintf(fresult, "Start X0\n");
	do {
		i = code[pc];
		pc = pc + 1;
		switch (i.f) {
			case lit:
				break;
			case opr:
				switch (*(int*)&(i.opr)) {
					case 0:								// return
						break;
					case 1:								// Negative
						break;
					case 2:								// 2 opr +
						break;
					case 3:								// 2 opr -
						break;
					case 4:								// 2 opr *
						break;
					case 5:								// 2 opr /
						break;
					case 6:								// 2 opr %
						break;
					case 7:								// 2 opr ==
						break;
					case 8:								// 2 opr !=
						break;
					case 9:								// 2 opr <
						break;
					case 10:							// 2 opr <=
						break;
					case 11:							// 2 opr >
						break;
					case 12:							// 2 opr >=
						break;
					case 13:							// 2 opr &&
						break;
					case 14:							// 2 opr ||
						break;
					case 15:							// 2 opr ^^
					case 16:							// 1 opr !
						break;
					case 17:							// 1 opr ++
						break;
					case 18:							// 1 opr --
						break;
					case 19:							// output
						break;
					case 20:							// input
						break;
					case 21: 							// >>
						break;
					case 22:							// <<
						break;
					case 23:							// pop from the stack
						break;
					case 24:							// This == is especially for case, which will not pop the stack top after comparing
						break;
				}
				break;
			case lod:
				break;
			case sto:
				break;
			case cal:
				break;
			case ini:
				break;
			case jmp:
				break;
			case jpc:
				break;
			case off:
				break;
		}
	} while (pc != vm_code_pointer);
}

int type_max(int a, int b) {
	return a > b ? a : b;
}

void back_patch(int ins_idx, byte op[STRING_LEN]) {
	memcpy((void*)code[ins_idx].opr, (const void*)&op, STRING_LEN);
}

void listall() {
	int i;
	char name[][5] = {
		{"lit"}, {"opr"}, {"lod"}, {"sto"},
		{"cal"}, {"ini"}, {"jmp"}, {"jpc"}, {"off"}
	};
	for (i = 0; i < vm_code_pointer; i++) {
		
	}
}

void print_data_stack() {
	int i = 3;
	for (; i <= stack_top; i++) {
		
	}
	printf("==========================================================================\n");
}

int main(int argc, int **argv) {
	int tok;
	fcode = fopen("fcode", "w+");
	ftable = fopen("ftable", "w+");
	fresult = fopen("fresult", "w+");
	if (argc != 2) {
		printf("Please specific ONE source code file!\n");
		return 0;
	}
	FILE *f = fopen(argv[1], "r");
	if (!f) {
		perror(argv[1]);
		return 1;
	}
	redirectInput(f);
	init();
	int opran = 0;
	//while (tok = yylex()) printf("%d\n", tok);
	yyparse();
	//display_sym_tab();
	//listall();
	//interpret();
	//listall();
	//print_data_stack();
}
