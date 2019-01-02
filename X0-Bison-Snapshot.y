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
							cur_level = 0;
							memset(break_statement_address, -1, sizeof break_statement_address);
							memset(continue_statement_address, -1, sizeof continue_statement_address);
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
						  	constant_decl_or_not = 0; 
							memset(tmp_arr_list, 0, sizeof tmp_arr_list); 
							tmp_arr_dim_idx = 0;
						} SEMICOLON
					  | CONSTSYM typeenum { constant_decl_or_not = 1; } identlist { constant_decl_or_not = 0; } SEMICOLON
					  | CONSTSYM typeenum { 
						  	constant_decl_or_not = 1; 
							memset(tmp_arr_list, 0, sizeof tmp_arr_list); 
							tmp_arr_dim_idx = 0;
						} identarraylist { constant_decl_or_not = 0; } SEMICOLON;
						;

identlist:				identdef 
					  |	identlist COMMA identdef
					  	;

identdef:				IDENT {
							if (constant_decl_or_not == 1) {		// Constant without initialize, error
								yyerror("Constants require initialization!\n");
								return 1;
							} 
							else {
								var_decl_with_init_or_not = 0;
								strcpy(id_name, $1);
								switch (cur_decl_type) {
									case 2:
										enter(variable_int);
										break;
									case 3:
										enter(variable_real);
										break;
									case 4:
										enter(variable_string);
										break;
									case 5:
										enter(variable_bool);
										break;
									case 6:
										enter(variable_char);
										break;
								}
							}
	 					}
					  |	IDENT BECOMES factor {
						  	if (constant_decl_or_not == 1) {		// Constant declaration
								if (cur_decl_type != $3) {
									yyerror("Inconpitable type!\n");
								}
								else {
								strcpy(id_name, $1);
									switch (cur_decl_type) {
										case 2:
											enter(constant_int);
											break;
										case 3:
											enter(constant_real);
											break;
										case 4:
											enter(constant_string);
											break;
										case 5:
											enter(constant_bool);
											break;
										case 6:
											enter(constant_char);
											break;
									}
								}
							}
							else {									// Variable declaration, pre-init required?
								var_decl_with_init_or_not = 1;
								strcpy(id_name, $1);
									switch (cur_decl_type) {
										case 2:
											enter(variable_int);
											break;
										case 3:
											enter(variable_real);
											break;
										case 4:
											enter(variable_string);
											break;
										case 5:
											enter(variable_bool);
											break;
										case 6:
											enter(variable_char);
											break;
									}
								//}
								int id_addr = 0;
								enum object tmp;
								for (int i = 1; i <= sym_tab_tail; i++) {
									if (strcmp($1, table[i].name) == 0) {
										id_addr = table[i].addr;
										tmp = table[i].kind;
										break;
									}
								}
								gen(sto, cur_decl_type, (byte*)id_addr);
								var_decl_with_init_or_not = 0;
							}
					  	}
						;

typeenum:				INTSYM 		{ cur_decl_type = 2; }
					  | STRINGSYM 	{ cur_decl_type = 4; }
					  | BOOLSYM 	{ cur_decl_type = 5; }
					  | REALSYM 	{ cur_decl_type = 3; }
					  | CHARSYM		{ cur_decl_type = 6; }
						;

identarraylist:			identarraydef
					  |	identarraylist COMMA identarraydef
						;
				
identarraydef:			IDENT LBRACKET dimensionlist RBRACKET {
							arr_size = $3;
							strcpy(id_name, $1);
							int i;
							for (i = 0; i < MAX_ARR_DIM; i++) {
								int tmp;
								tmp = tmp_arr_list[i];
								tmp_arr_list[i] = tmp_arr_list[MAX_ARR_DIM - 1 - i];
								tmp_arr_list[MAX_ARR_DIM - 1 - i] = tmp;
							}
							if (constant_decl_or_not == 1) {
								switch (cur_decl_type) {
									case 2:
										enter(constant_int_array);
										break;
									case 3:
										enter(constant_real_array);
										break;
									case 4:
										enter(constant_string_array);
										break;
									case 5:
										enter(constant_bool_array);
										break;
									case 6:
										enter(constant_char_array);
										break;
								}
							}
							else {
								switch (cur_decl_type) {
									case 2:
										enter(variable_int_array);
										break;
									case 3:
										enter(variable_real_array);
										break;
									case 4:
										enter(variable_string_array);
										break;
									case 5:
										enter(variable_bool_array);
										break;
									case 6:
										enter(variable_char_array);
										break;
								}
							}
							memset(tmp_arr_list, 0, sizeof tmp_arr_list);
							tmp_arr_dim_idx = 0;
							arr_size = 0;
						}
						;

dimensionlist:			dimension {
							$$ = $1;
							tmp_arr_list[tmp_arr_dim_idx++] = $1;
						}
					  | dimensionlist COMMA dimension {
						  	$$ = $1 * $3;
							tmp_arr_list[tmp_arr_dim_idx++] = $3;
					  	}
					  	;

dimension:				INTEGER {
							$$ = $1;
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
							int iter;
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (break_statement_address[cur_level][iter] != -1) {
									memcpy((void*)code[break_statement_address[cur_level][iter]].opr, (const void*)&vm_code_pointer, STRING_LEN);
								}
								else {
									break;
								}
							}
						}
						;

case_list:				case_list case_stat {
						  	int dest = $2->case_end;
							memcpy((void*)code[$2->case_start].opr, (const void*)&dest, STRING_LEN);
						}
					  |	case_stat {
						  	int dest = $1->case_end;
							memcpy((void*)code[$1->case_start].opr, (const void*)&dest, STRING_LEN);
					  	}
					  |
						;

case_stat:				CASESYM expression COLON {
							int opran;
							opran = 24;
							gen(opr, $2, (byte*)opran);
							$1 = vm_code_pointer;
							opran = 0;
							gen(jpc, 0, (byte*)opran);
						} compound_statement {
							$$ = (struct bp_list*)malloc(sizeof (struct bp_list));
							$$->case_start = $1;
							$$->case_end = vm_code_pointer;
						}
					  | 
						;

default_statement:		DEFAULTSYM COLON compound_statement {
							$$ = (struct bp_list*)malloc(sizeof (struct bp_list));
							$$->case_start = $1;
							$$->case_end = vm_code_pointer;
						}
						;
						
continue_stat:			CONTINUESYM SEMICOLONSTAT {
							int continue_statement_address_idx = 0, iter, level = cur_level - 1;
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (continue_statement_address[level][iter] < 0) {
									continue_statement_address[level][iter] = vm_code_pointer;
									break;
								}
							}
							int opran = 0;
							gen(jmp, 0, (byte*)opran);
						}
						;
						
break_stat:				BREAKSYM SEMICOLONSTAT {
							int break_statement_address_idx = 0, iter, level = cur_level - 1;
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (break_statement_address[level][iter] < 0) {
									break_statement_address[level][iter] = vm_code_pointer;
									break;
								}
							}
							int opran = 0;
							gen(jmp, 0, (byte*)opran);
						}
						;
						
if_statement:		  	IFSYM LPARENSTAT expression RPARENSTAT { //// @todo: Causion: if ++ -- in expression, should pop a result from the data stack, not the problem of ++ -- 
							cur_level --; 
							int opran = 0;
							gen(jpc, 0, (byte*)opran);
						} compound_statement {
							int static_back_patch_idx = $4, static_back_patch_val = vm_code_pointer;
							memcpy((void*)code[static_back_patch_idx].opr, (const void*)&static_back_patch_val, STRING_LEN);
					  	} else_list {
							int else_remedy_idx = $4, else_remedy_val = $6 + 1;
							cur_level++;
							if ($8 == 1) {
								memcpy((void*)code[else_remedy_idx].opr, (const void*)&else_remedy_val, STRING_LEN);
							}
						}
						;

else_list:				ELSESYMSTAT { 
							else_compound = 1;
							int opran = 0;
							gen(jmp, 0, (byte*)opran);
						} compound_statement { 
							int static_back_patch_val = $3, static_back_patch_idx = $1;
							memcpy((void*)code[static_back_patch_idx].opr, (const void*)&static_back_patch_val, STRING_LEN);
							else_compound = 0;
							$$ = 1;
						}
					  |	{ $$ = 0; }
						;

ELSESYMSTAT:			ELSESYM { $$ = vm_code_pointer; }
						;

while_statement:		WHILESYMSTAT LPARENSTAT expression RPARENSTAT { // @todo: Causion: if ++ -- in expression, should pop a result from the data stack, not the problem of ++ -- 
							int opran;
							gen(jpc, 0, (byte*)opran);
							if (inc_flag) {
								inc_flag = 0;
								opran = 23;					// pop ++ --
								//gen(opr, 2, (byte*)opran); // ??? to be determined
							}
						} compound_statement {
							int while_start_idx = $1, static_back_patch_idx = $4, while_static_back_patch_idx = $4;
							gen(jmp, 0, (byte*)while_start_idx);
							int while_static_back_patch_val = vm_code_pointer;
							memcpy((void*)code[while_static_back_patch_idx].opr, (const void*)&while_static_back_patch_val, STRING_LEN);
							int iter;
							//printf("curr while level %d\n", cur_level);
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (break_statement_address[cur_level][iter] != -1) {
									memcpy((void*)code[break_statement_address[cur_level][iter]].opr, (const void*)&vm_code_pointer, STRING_LEN);
								}
								else {
									break;
								}
							}
							int continue_destination = $1;
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (continue_statement_address[cur_level][iter] != -1) {
									memcpy((void*)code[continue_statement_address[cur_level][iter]].opr, (const void*)&continue_destination, STRING_LEN);
								}
								else {
									break;
								}
							}
						}
						;
WHILESYMSTAT:			WHILESYM {$$ = vm_code_pointer;}
						;
	
write_statement:		WRITESYM LPARENSTAT expression RPARENSTAT SEMICOLONSTAT {
							int opran = 19;
							gen(opr, $3, (byte*)opran);
						}
						;
	
read_statement:			READSYM LPARENSTAT var RPARENSTAT SEMICOLONSTAT {
							int id_addr;
							enum object tmp;
							for (int i = 1; i <= sym_tab_tail; i++) {
								if (strcmp(curr_read_write_ident, table[i].name) == 0) {
									id_addr = table[i].addr;
									tmp = table[i].kind;
									break;
								}
							}
							int lev, opran;
							switch (tmp) {
								case constant_int:
								case constant_int_array:
									yyerror("Trying to change constant variable!\n");
									break;
								case variable_int:
								case variable_int_array:
									lev = 2;
									break;
								case constant_real:
								case constant_real_array:
									yyerror("Trying to change constant variable!\n");
									break;
								case variable_real:
								case variable_real_array:
									lev = 3;
									break;
								case constant_string:
								case constant_string_array:
									yyerror("Trying to change constant variable!\n");
									break;
								case variable_string:
								case variable_string_array:
									lev = 4;
									break;
								case constant_char:
								case constant_char_array:
									yyerror("Trying to change constant variable!\n");
									break;
								case variable_char:
								case variable_char_array:
									lev = 6;
									break;
								case constant_bool:
								case constant_bool_array:
									yyerror("Trying to change constant variable!\n");
									break;
								case variable_bool:
								case variable_bool_array:
									lev = 5;
									break;
							}
							opran = 20;
							gen(opr, lev, (byte*)opran);
							opran = id_addr;
							gen(sto, lev, (byte*)opran);
						}
						;
						
compound_statement:		LBRACE {		// Please re-construct here, put gen(jpc/jmp) out of the compound statements
							cur_level++;
							//static_back_patch_idx = vm_code_pointer;
							//int opran = 0;
							//if (!else_compound) gen(jpc, 0, (byte*)opran);
							//else gen(jmp, 0, (byte*)opran);
						} statement_list RBRACE {
							cur_level--;
							$$ = vm_code_pointer;
						}
						;
						
for_statement:			FORSYM LPARENSTAT 
						expression SEMICOLONSTAT {				// e1
							//if_e2_enter = vm_code_pointer;
						}
						expression SEMICOLONSTAT {				// e2
							int opran = 0;
							//if_s_end_idx = vm_code_pointer;
							if ($6 != -1) gen(jpc, 0, (byte*)opran);
							//if_s_enter_idx = vm_code_pointer;
							gen(jmp, 0, (byte*)opran);
							//if_e3_enter = vm_code_pointer;
						}			
						expression RPARENSTAT INC_OR_NOT {					// e3
							int opran;
							$11 = inc_flag;
							if (inc_flag) {
								inc_flag = 0;
								opran = 23;					// pop ++ --
								gen(opr, 2, (byte*)opran);
							}
							//if_e2_enter_idx = vm_code_pointer;
							gen(jmp, 0, (byte*)opran);
							//if_s_enter = vm_code_pointer;
						}
						compound_statement {
							int opran = 0;
							//if_e3_enter_idx = vm_code_pointer;
							int if_s_end_idx = $7, if_s_enter_idx = $7 + ($6 == -1 ? 0 : 1), if_e2_enter_idx = $10 + ($11 == 1 ? 1 : 0), if_e3_enter_idx = vm_code_pointer;
							int if_s_end = vm_code_pointer + 1, if_s_enter = $10 + 1 + ($11 == 1 ? 1 : 0), if_e2_enter = $4, if_e3_enter = $7 + 2;
							gen(jmp, 0, (byte*)opran);
							if ($6 != -1) memcpy((void*)code[if_s_end_idx].opr, (const void*)&if_s_end, STRING_LEN);
							memcpy((void*)code[if_s_enter_idx].opr, (const void*)&if_s_enter, STRING_LEN);
							memcpy((void*)code[if_e2_enter_idx].opr, (const void*)&if_e2_enter, STRING_LEN);
							memcpy((void*)code[if_e3_enter_idx].opr, (const void*)&if_e3_enter, STRING_LEN);
							int iter;
							//printf("%d %d\n", cur_level, vm_code_pointer);
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (break_statement_address[cur_level][iter] != -1) {
									memcpy((void*)code[break_statement_address[cur_level][iter]].opr, (const void*)&vm_code_pointer, STRING_LEN);
								}
								else {
									break;
								}
							}
							int continue_destination = $7 + 2;
							for (iter = 0; iter < STRING_LEN; iter++) {
								if (continue_statement_address[cur_level][iter] != -1) {
									memcpy((void*)code[continue_statement_address[cur_level][iter]].opr, (const void*)&continue_destination, STRING_LEN);
								}
								else {
									break;
								}
							}
						}
						;
						
INC_OR_NOT:				
						;

do_statement:			DOSYM { 
							do_start_idx = vm_code_pointer;
						} compound_statement WHILESYM LPAREN expression RPARENSTAT {
							int opran;
							opran = 0;
							gen(jpc, 0, (byte*)opran);
							gen(jmp, 0, (byte*)do_start_idx);
							memcpy((void*)code[vm_code_pointer - 2].opr, (const void*)&vm_code_pointer, STRING_LEN);
						} SEMICOLONSTAT
						;
	
var:					IDENT {
							array_offset = 0;
							$$ = -1;												// var == -1 means IDENT not exists, for := using
							char name_buf[81];
							strcpy(name_buf, $1);
							int i, flag = 0;
							for (i = 1; i <= sym_tab_tail; i++) {
								if (strcmp(name_buf, table[i].name) == 0) {
									flag++;
									if (flag == 1) strcpy(curr_read_write_ident, $1);
									switch (table[i].kind) {
										case constant_int:
										case variable_int:
											$$ = 2;
											break;
										case constant_real:
										case variable_real:
											$$ = 3;
											break;
										case constant_string:
										case variable_string:
											$$ = 4;
											break;
										case constant_char:
										case variable_char:
											$$ = 6;
											break;
										case constant_bool:
										case variable_bool:
											$$ = 5;
											break;
									}
								}
							}
							if (flag == 0) {
								yyerror("Undefined variable!\n");
							}
							else if (flag > 1) {
								yyerror("Duplicated variable defination!\n");
							}
						}
					  | IDENT LBRACKET expression_list RBRACKET {
						  	// curr_ident_array_or_not = 1;
						  	$$ = -1;
							char name_buf[81];
							int idx = -1, cnt = 0, opran = 0, base_addr;
							strcpy(name_buf, $1);
							int i, flag = 0;
							for (i = 1; i <= sym_tab_tail; i++) {
								if (strcmp(name_buf, table[i].name) == 0) {
									flag++;
									if (flag == 1) {
										idx = i;
										base_addr = table[i].addr;
										strcpy(curr_read_write_ident, $1);
									}
									switch (table[i].kind) {
										case constant_int_array:
										case variable_int_array:
											$$ = 2;
											break;
										case constant_real_array:
										case variable_real_array:
											$$ = 3;
											break;
										case constant_string_array:
										case variable_string_array:
											$$ = 4;
											break;
										case constant_char_array:
										case variable_char_array:
											$$ = 6;
											break;
										case constant_bool_array:
										case variable_bool_array:
											$$ = 5;
											break;
									}
								}
							}
							for (i = 0; i < MAX_ARR_DIM; i++) {
								tmp_arr_list[i] = table[idx].array_dim[i];
								if (tmp_arr_list[i]) cnt++;
							}
							for (i = MAX_ARR_DIM - 1; i >= 0; i--) {
								if (tmp_arr_list[i]) {
									tmp_arr_list[i] = 1;
									break;
								}
							}
							opran = base_addr;
							gen(off, cnt, (byte*)opran);
							opran = 0;
							tmp_arr_dim_idx = 0;
							if (flag == 0) {
								yyerror("Undefined variable!\n");
							}
							else if (flag > 1) {
								yyerror("Duplicated variable defination!\n");
							}
					  	}
						;

expression_list:		expression {
							$$ = $1;
						}
					  | expression_list COMMA expression {
						  	$1 = $3;
							$$ = $1;
					  	}
						;

expression_statement:	expression SEMICOLONSTAT {
							// int opran;
							// if (inc_flag) {
							// 	inc_flag = 0;
							// 	opran = 23;					// pop ++ --
							// 	gen(opr, 2, (byte*)opran);
							// }
						} 
					  | SEMICOLONSTAT
						;

expression:				var {
							glob_var_addr = find_addr_of_ident(curr_read_write_ident);
						} 
						BECOMES expression {
							$$ = 0;
							if ($1 == -1) {
								yyerror("Variable not defined!\n");
							}
							// if (curr_ident_array_or_not) {
							// 	back_patch_list[back_patch_idx++] = vm_code_pointer;
							// 	glob_var_addr = -1;
							// }
							gen(sto, $1, (byte*)glob_var_addr);
						}
					  | simple_expr {
						  	$$ = $1;
					  	}
					  | { $$ = -1; }
						;

simple_expr:			additive_expr { $$ = $1; }
					  | additive_expr OPR additive_expr { 
						  	$$ = 5; 						// res is bool
							int opran;
							if ($1 != $3) {
								yyerror("Different type between bool operator!\n");
							}
							opran = $2 + 6;					// reference line 1284 and line 679
							gen(opr, $1, (byte*)opran);
						}
					  | additive_expr SINGLEOPR { 
						  	$$ = $1;
						  	int var_addr = find_addr_of_ident(curr_read_write_ident);
							gen(lod, 2, (byte*)var_addr);
							int opran = 1;
							gen(lit, 2, (byte*)&opran);
							opran = ($2 == 1 ? 2 : 3);
							gen(opr, 2, (byte*)opran);
							gen(sto, 2, (byte*)var_addr);
							inc_flag = 1;
						}
					  | SINGLEOPR additive_expr { 
						  	// @todo: Finish stuff like ++a --a 
						  	$$ = $2; 
							int opran;
							if ($1 == 1 || $1 == 2) {
								opran = 1;
								int var_addr = find_addr_of_ident(curr_read_write_ident);
								gen(lit, 2, (byte*)&opran);
								opran = ($1 == 1 ? 2 : 3);
								gen(opr, 2, (byte*)opran);
								gen(sto, 2, (byte*)var_addr);
								gen(lod, 2, (byte*)var_addr);
								inc_flag = 1;
							}
							else {
								opran = 16;
								gen(opr, $2, (byte*)opran);
							}
						}
						;

SINGLEOPR:				INCPLUS {
							$$ = 1;
						}
					  | INCMINUS {
						  	$$ = 2;
					  	}
					  | NOT {
						  	$$ = 3;
					  	}
						;

OPR:					EQL {
							$$ = 1;
						}
					  | NEQ {
						  	$$ = 2;
					  	}
					  | LSS {
						  	$$ = 3;
					  	}
					  | LEQ {
						  	$$ = 4;
					  	}
					  | GTR {
						  	$$ = 5;
					  	}
					  | GEQ {
						  	$$ = 6;
					  	}
					  | AND {
						  	$$ = 7;
					  	}
					  | OR {
						  	$$ = 8;
					 	}
					  | XOR {
						  	$$ = 9;
					 	}
					  | BITAND {
						  	$$ = 11;
					  	}
					  | BITOR {
						  	$$ = 12;
					  	}
					  | RR {
						  	$$ = 15;
					  	}
					  | RL {
						  	$$ = 16;
					  	}
						;

additive_expr:			term {
							$$ = $1;
						}
					  | additive_expr PLUSMINUS term {
							$$ = type_max($1, $3);
							int opran = ($2 == 1 ? 2 : 3);
							gen(opr, $$, (byte*)opran);
					  	}
						;

PLUSMINUS:				PLUS {
							$$ = 1;
						}
					  | MINUS {
						  	$$ = 2;
					 	}
						;

term:					factor {
							$$ = $1;
						}
					  | term TIMESDEVIDE factor {
							$$ = type_max($1, $3);
							int opran = ($2 == 1 ? 4 : ($2 == 2 ? 5 : 6));
							gen(opr, $$, (byte*)opran);
					  	}
						;

TIMESDEVIDE:			TIMES {
							$$ = 1;
						}
					  | DEVIDE {
						  	$$ = 2;
					  	}
					  | MOD {
						  	$$ = 3;
					  	}
						;

factor:					LPARENSTAT expression RPARENSTAT {
							$$ = $2;
						}
					  | var {
						  	$$ = $1;
							int constant_or_not = 0, idx = -1;
							int i;
							for (i = 1; i <= sym_tab_tail; i++) {
								if (strcmp(table[i].name, curr_read_write_ident) == 0) {
									switch (table[i].kind) {
										case constant_int:
										case constant_real:
										case constant_bool:
										case constant_char:
										case constant_string:
											idx = i;
											constant_or_not = 1;
											break;
									}
									break;
								}
							}
							if (constant_or_not) {										// using constant variable
								gen(lit, $1, table[idx].val);
							}
							else {
								int var_addr = find_addr_of_ident(curr_read_write_ident);
								int i;
								for (i = 1; i <= sym_tab_tail; i++) {
									if (strcmp(table[i].name, curr_read_write_ident) == 0) {
										if (table[i].init_or_not == 1) {
											memcpy((void*)&s[table[i].addr].val, (const void*)&table[i].val, STRING_LEN);
											break;
										}
									}
								}
								gen(lod, $1, (byte*)var_addr);
							}
							stack_top++;
					  	}
					  | INTEGER {
						  	$$ = 2;
							outter_int = $1;
							gen(lit, 2, (byte*)&outter_int);
					  	}
					  | REAL {
						  	$$ = 3;
							outter_real = $1;
							gen(lit, 3, (byte*)&outter_real);
					  	}
					  | STRING {
						  	$$ = 4;
							strcpy(outter_string, $1);
							gen(lit, 4, outter_string);
					  	}
					  | BOOL {
						  	$$ = 5;
							outter_bool = $1;
							gen(lit, 5, (byte*)&outter_bool);
					  	}
					  | CHAR {
						  	$$ = 6;
							outter_char = $1;
							gen(lit, 6, (byte*)&outter_char);
					  	}
					  | YAJU {
						  	$$ = 7;
					  	}
						;

SEMICOLONSTAT:			SEMICOLON {$1 = vm_code_pointer; $$ = $1;}
						;
				
LPARENSTAT:				LPAREN {$1 = vm_code_pointer; $$ = $1; }
						;

RPARENSTAT:				RPAREN {$1 = vm_code_pointer; $$ = $1;}
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
	if (vm_code_pointer > CODE_MAX) {
		printf("Program is too long!\n");
		exit(1);
	}
	code[vm_code_pointer].f 	= x;
	code[vm_code_pointer].lev 	= y;
	if (x == lit) memcpy((void*)(code[vm_code_pointer].opr), (const void*)z, STRING_LEN); // lit has different behavior with other instruction, causion.
	else memcpy((void*)(code[vm_code_pointer].opr), (const void*)&z, STRING_LEN);
	vm_code_pointer++;
}

void enter(enum object k) {
	sym_tab_tail++;
	strcpy(table[sym_tab_tail].name, id_name);
	table[sym_tab_tail].kind = k;
	table[sym_tab_tail].init_or_not = 0;
	switch (k) {
		case constant_int:
			memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_int, STRING_LEN);
			break;
		case constant_real:
			memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_real, STRING_LEN);
			break;
		case constant_string:
			memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_string, STRING_LEN);
			break;
		case constant_char:
			memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_char, STRING_LEN);
			break;
		case constant_bool:
			memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_bool, STRING_LEN);
			break;
		case variable_int:
			if (var_decl_with_init_or_not) {
				memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_int, STRING_LEN);
				table[sym_tab_tail].init_or_not = 1;
			}
			table[sym_tab_tail].addr = curr_address++;
			break;
		case variable_real:
			if (var_decl_with_init_or_not) {
				memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_real, STRING_LEN);
				table[sym_tab_tail].init_or_not = 1;
			}
			table[sym_tab_tail].addr = curr_address++;
			break;
		case variable_string:
			if (var_decl_with_init_or_not) {
				memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_string, STRING_LEN);
				table[sym_tab_tail].init_or_not = 1;
			}
			table[sym_tab_tail].addr = curr_address++;
			break;
		case variable_char:
			if (var_decl_with_init_or_not) {
				memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_char, STRING_LEN);
				table[sym_tab_tail].init_or_not = 1;
			}
			table[sym_tab_tail].addr = curr_address++;
			break;
		case variable_bool:
			if (var_decl_with_init_or_not) {
				memcpy((void*)&table[sym_tab_tail].val, (const void*)&outter_bool, STRING_LEN);
				table[sym_tab_tail].init_or_not = 1;
			}
			table[sym_tab_tail].addr = curr_address++;
			break;
		case constant_int_array:
		case constant_real_array:
		case constant_bool_array:
		case constant_char_array:
		case constant_string_array:
			table[sym_tab_tail].array_const_or_not = 1;
		case variable_int_array:
		case variable_real_array:
		case variable_bool_array:
		case variable_char_array:
		case variable_string_array:
			table[sym_tab_tail].addr = curr_address;
			table[sym_tab_tail].array_size = arr_size;
			curr_address += arr_size;
			int j;
			for (j = 0; j < MAX_ARR_DIM; j++) {
				table[sym_tab_tail].array_dim[j] = tmp_arr_list[j];
			}
			break;
	}
}

void display_sym_tab() {			// @todo: Finish sym-table displaying
	int i, j;
	for (i = 1; i <= sym_tab_tail; i++) {
		switch (table[i].kind) {
			case constant_int:
				printf("%10d\tconstant\tinteger\t%20s:\t", i, table[i].name);
				printf("value = %d\n", *((int*)&table[i].val));
				fprintf(ftable, "%10d\tconstant\tinteger\t%20s:\t", i, table[i].name);
				fprintf(ftable, "value = %d\n", *((int*)&table[i].val));
				break;
			case constant_real:
				printf("%10d\tconstant\treal\t%20s:\t", i, table[i].name);
				printf("value = %f\n", *((float*)&table[i].val));
				fprintf(ftable, "%10d\tconstant\treal\t%20s:\t", i, table[i].name);
				fprintf(ftable, "value = %f\n", *((float*)&table[i].val));
				break;
			case constant_char:
				printf("%10d\tconstant\tchar\t%20s:\t", i, table[i].name);
				printf("value = %c\n", *((char*)&table[i].val));
				fprintf(ftable, "%10d\tconstant\tchar\t%20s:\t", i, table[i].name);
				fprintf(ftable, "value = %c\n", *((char*)&table[i].val));
				break;
			case constant_string:
				printf("%10d\tconstant\tstring\t%20s:\t", i, table[i].name);
				printf("value = %s\n", table[i].val);
				fprintf(ftable, "%10d\tconstant\tstring\t%20s:\t", i, table[i].name);
				fprintf(ftable, "value = %s\n", table[i].val);
				break;
			case constant_bool:
				printf("%10d\tconstant\tbool\t%20s:\t", i, table[i].name);
				printf("value = %s\n", (*((int*)&table[i].val) == 0) ? "false" : "true");
				fprintf(ftable, "%10d\tconstant\tbool\t%20s:\t", i, table[i].name);
				fprintf(ftable, "value = %s\n", (*((int*)&table[i].val) == 0) ? "false" : "true");
				break;
			case variable_int:
				printf("%10d\tvariable\tinteger\t%20s\taddress:%10d => ", i, table[i].name, table[i].addr);
				printf("Initialized or not = %d\n", table[i].init_or_not);
				fprintf(ftable, "%10d\tvariable\tinteger\t%20s:\t", i, table[i].name);
				fprintf(ftable, "Initialized or not = %d\n", table[i].init_or_not);
				break;
			case variable_real:
				printf("%10d\tvariable\treal\t%20s:\taddress:%10d => ", i, table[i].name, table[i].addr);
				printf("Initialized or not = %d\n", table[i].init_or_not);
				fprintf(ftable, "%10d\tvariable\treal\t%20s:\t", i, table[i].name);
				fprintf(ftable, "Initialized or not = %d\n", table[i].init_or_not);
				break;
			case variable_char:
				printf("%10d\tvariable\tcahr\t%20s:\taddress:%10d => ", i, table[i].name, table[i].addr);
				printf("Initialized or not = %d\n", table[i].init_or_not);
				fprintf(ftable, "%10d\tvariable\tchar\t%20s:\t", i, table[i].name);
				fprintf(ftable, "Initialized or not = %d\n", table[i].init_or_not);
				break;
			case variable_string:
				printf("%10d\tvariable\tstring\t%20s\taddress:%10d => ", i, table[i].name, table[i].addr);
				printf("Initialized or not = %d\n", table[i].init_or_not);
				fprintf(ftable, "%10d\tvariable\tstring\t%20s:\t", i, table[i].name);
				fprintf(ftable, "Initialized or not = %d\n", table[i].init_or_not);
				break;
			case variable_bool:
				printf("%10d\tvariable\tbool\t%20s:\taddress:%10d => ", i, table[i].name, table[i].addr);
				printf("Initialized or not = %d\n", table[i].init_or_not);
				fprintf(ftable, "%10d\tvariable\tbool\t%20s:\t", i, table[i].name);
				fprintf(ftable, "Initialized or not = %d\n", table[i].init_or_not);
				break;
			case constant_int_array:
			case constant_real_array:
			case constant_bool_array:
			case constant_char_array:
			case constant_string_array:
				printf("%10d\tconstant\tarray\t%20s:\taddress:%10d => Dimension:", i, table[i].name, table[i].addr);
				for (j = 0; j < MAX_ARR_DIM; j++) {
					printf("%2d%c", table[i].array_dim[j], j == MAX_ARR_DIM - 1 ? '\n' : ',');
				}
				fprintf(ftable, "%10d\tconstant\tarray\t%20s:\taddress:%10d\n", i, table[i].name, table[i].addr);
				break;
			case variable_int_array:
			case variable_real_array:
			case variable_bool_array:
			case variable_char_array:
			case variable_string_array:
				printf("%10d\tvariable\tarray\t%20s:\taddress:%10d => Dimension:", i, table[i].name, table[i].addr);
				for (j = 0; j < MAX_ARR_DIM; j++) {
					printf("%2d%c", table[i].array_dim[j], j == MAX_ARR_DIM - 1 ? '\n' : ',');
				}
				fprintf(ftable, "%10d\tvariable\tarray\t%20s:\taddress:%10d\n", i, table[i].name, table[i].addr);
				break;
		}
	}
}

int find_addr_of_ident(char *s) {
	int addr = -1;
	int i;
	for (i = 1; i <= sym_tab_tail; i++) {
		if (strcmp(table[i].name, s) == 0) {
			addr = table[i].addr;
			break;
		}
	}
	return addr;
}

void interpret() {
	// Unknown error of unexpected output!
	int 		pc = 0;
	int 		base = 1;
	struct 		instruction i;
	int			addr;
	int			iter;
	int			jter;
	int			res;
	int 		addr_to_find_array_in_table;
	int			bool_opr1, bool_opr2;
	int			array_input = 0;
	int			input_flag = 0;
	memset(inbuf_string, 0, sizeof inbuf_string);
	printf("Start X0\n");
	fprintf(fresult, "Start X0\n");
	do {
		i = code[pc];
		pc = pc + 1;
		switch (i.f) {
			case lit:
				stack_top++;
				memcpy((void*)(&(s[stack_top].val)), (const void*)(&i.opr), STRING_LEN);
				switch (i.lev) {
					case 2:
						s[stack_top].t = integer;
						break;
					case 3:
						s[stack_top].t = real;
						break;
					case 4:
						s[stack_top].t = str;
						break;
					case 5:
						s[stack_top].t = boolean;
						break;
					case 6:
						s[stack_top].t = single_char;
						break;
				}
				break;
			case opr:
				switch (*(int*)&(i.opr)) {
					case 0:								// return
						stack_top = base - 1;
						pc = *(int*)(&(s[stack_top + 3].val));
						base = *(int*)(&(s[stack_top + 2].val));
						break;
					case 1:								// Negative
						break;
					case 2:								// 2 opr +
						stack_top--;
						switch (s[stack_top].t) {
							case integer:
								switch (s[stack_top + 1].t) {
									case integer:
										outter_int = *(int*)&s[stack_top].val + *(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
										s[stack_top].t = integer;
										break;
									case real:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = (float)*(int*)&s[stack_top].val + *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
									default: {
										yyerror("Operators Incompitable!\n");
									}
								}
								break;
							case real:
								switch (s[stack_top + 1].t) {
									case real:
										outter_real = *(float*)&s[stack_top].val + *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										s[stack_top].t = real;
										break;
									case integer:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = *(float*)&s[stack_top].val + (float)*(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
								}
								break;
							case str:
								// @todo: implement strcat
								break;
							case single_char:
							case boolean: 
								yyerror("Operant not support + operation!\n");
								break;
							
						}
						break;
					case 3:								// 2 opr -
						stack_top--;
						switch (s[stack_top].t) {
							case integer:
								switch (s[stack_top + 1].t) {
									case integer:
										outter_int = *(int*)&s[stack_top].val - *(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
										s[stack_top].t = integer;
										break;
									case real:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = (float)*(int*)&s[stack_top].val - *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
									default: {
										yyerror("Operators Incompitable!\n");
									}
								}
								break;
							case real:
								switch (s[stack_top + 1].t) {
									case real:
										outter_real = *(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										s[stack_top].t = real;
										break;
									case integer:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = *(float*)&s[stack_top].val - (float)*(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
								}
								break;
							case str:
								break;
							case single_char:
							case boolean: 
								yyerror("Operant not support - operation!\n");
								break;
						}
						break;
					case 4:								// 2 opr *
						stack_top--;
						switch (s[stack_top].t) {
							case integer:
								switch (s[stack_top + 1].t) {
									case integer:
										outter_int = *(int*)&s[stack_top].val * *(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
										s[stack_top].t = integer;
										break;
									case real:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = (float)*(int*)&s[stack_top].val * *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
									default: {
										yyerror("Operators Incompitable!\n");
									}
								}
								break;
							case real:
								switch (s[stack_top + 1].t) {
									case real:
										outter_real = *(float*)&s[stack_top].val * *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										s[stack_top].t = real;
										break;
									case integer:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = *(float*)&s[stack_top].val * (float)*(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
								}
								break;
							case str:
							case single_char:
							case boolean: 
								yyerror("Operant not support * operation!\n");
								break;
						}
						break;
					case 5:								// 2 opr /
						stack_top--;
						switch (s[stack_top].t) {
							case integer:
								switch (s[stack_top + 1].t) {
									case integer:
										outter_int = *(int*)&s[stack_top].val / *(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
										s[stack_top].t = integer;
										break;
									case real:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = (float)*(int*)&s[stack_top].val / *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
									default: {
										yyerror("Operators Incompitable!\n");
									}
								}
								break;
							case real:
								switch (s[stack_top + 1].t) {
									case real:
										outter_real = *(float*)&s[stack_top].val / *(float*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										s[stack_top].t = real;
										break;
									case integer:
										s[stack_top + 1].t = real;
										s[stack_top].t = real;
										outter_real = *(float*)&s[stack_top].val / (float)*(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_real, STRING_LEN);
										break;
								}
								break;
							case str:
							case single_char:
							case boolean: 
								yyerror("Operant not support / operation!\n");
								break;
						}
						break;
					case 6:								// 2 opr %
						stack_top--;
						switch (s[stack_top].t) {
							case integer:
								switch (s[stack_top + 1].t) {
									case integer:
										outter_int = *(int*)&s[stack_top].val % *(int*)&s[stack_top + 1].val;
										memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
										s[stack_top].t = integer;
										break;
									default: {
										yyerror("Operators Incompitable!\n");
									}
								}
								break;
							case real:
							case str:
							case single_char:
							case boolean: 
								yyerror("Operant not support / operation!\n");
								break;
						}
						break;
					case 7:								// 2 opr ==
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val == *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = abs(*(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val) < FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = !strcmp(s[stack_top].val, s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								outter_int = (bool_opr1 * bool_opr2 || (!bool_opr1 && !bool_opr2)) ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val == *(char*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 8:								// 2 opr !=
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = !(*(int*)&s[stack_top].val == *(int*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = !(abs(*(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val) < FLOAT_EPS ? 1 : 0);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = strcmp(s[stack_top].val, s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								outter_int = !((bool_opr1 * bool_opr2 || (!bool_opr1 && !bool_opr2)) ? 1 : 0);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								outter_int = !(*(char*)&s[stack_top].val == *(char*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 9:								// 2 opr <
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val < *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = *(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val < -FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = strcmp(s[stack_top].val, s[stack_top + 1].val) < 0 ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val < *(char*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 10:							// 2 opr <=
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val <= *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = *(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val <= -FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = strcmp(s[stack_top].val, s[stack_top + 1].val) <= 0 ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val <= *(char*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 11:							// 2 opr >
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val > *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = *(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val > FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = strcmp(s[stack_top].val, s[stack_top + 1].val) > 0 ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val > *(char*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 12:							// 2 opr >=
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val >= *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = *(float*)&s[stack_top].val - *(float*)&s[stack_top + 1].val >= FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = strcmp(s[stack_top].val, s[stack_top + 1].val) >= 0 ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val >= *(char*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
					case 13:							// 2 opr &&
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val && *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 4:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								outter_int = bool_opr1 && bool_opr2;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 14:							// 2 opr ||
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val || *(int*)&s[stack_top + 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 4:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								outter_int = bool_opr1 || bool_opr2;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 15:							// 2 opr ^^
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								if ((bool_opr1 > 0 && bool_opr2 > 0) || (bool_opr1 == 0 && bool_opr2 == 0)) outter_int = 0;
								else outter_int = 1;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 4:
								yyerror("Opration not support for this type of variabls.");
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top + 1].val;
								if ((bool_opr1 > 0 && bool_opr2 > 0) || (bool_opr1 == 0 && bool_opr2 == 0)) outter_int = 0;
								else outter_int = 1;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 16:							// 1 opr !
						switch (i.lev) {
							case 2:
							case 5:
								outter_int = *(int*)&s[stack_top].val ? 1 : 0;
								outter_int = outter_int ? 0 : 1;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							default: {
								yyerror("Opration not support for this type of variabls.");
							}
						}
						break;
					case 17:							// 1 opr ++
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = (*(int*)&s[stack_top].val) & (*(int*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = integer;
								break;
							case 3:
							case 4:
							case 5:
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 18:							// 1 opr --
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = (*(int*)&s[stack_top].val) | (*(int*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = integer;
								break;
							case 3:
							case 4:
							case 5:
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 19:
						//printf("OUTPUT:\n");
						switch (s[stack_top].t) {
							case integer:
								printf("%d\n", *(int*)&s[stack_top].val);  
								break;
							case real:
								printf("%f\n", *(float*)&s[stack_top].val);        // e1 at this unit but when convert to %f it can't be displayed correctly.
								break;
							case str:
								printf("%s\n", s[stack_top].val);
								break;
							case boolean:
								printf("%s\n", (*(int*)&s[stack_top].val) == 0 ? "false" : "true");
								break;
							case single_char:
								printf("%c\n", *(char*)&s[stack_top].val);
								break;
						}
						stack_top--;
						break;
					case 20:							// input
						stack_top++;
						input_flag = !array_input;
						//printf("INPUT:\n");
						switch (i.lev) {
							case 2:
								scanf("%d", &inbuf_int);
								memcpy((void*)(&(s[stack_top].val)), (const void*)&inbuf_int, STRING_LEN);
								s[stack_top].t = integer;
								break;
							case 3:
								scanf("%f", &inbuf_real);
								memcpy((void*)(&(s[stack_top].val)), (const void*)&inbuf_real, STRING_LEN);
								s[stack_top].t = real;
								break;
							case 4:
								scanf("%s", inbuf_string);
								memcpy((void*)(&(s[stack_top].val)), (const void*)inbuf_string, STRING_LEN);
								s[stack_top].t = str;
								getchar();
								break;
							case 5:
								scanf("%s", &inbuf_bool);
								bool_flag = strcmp(inbuf_bool, "false");
								memcpy((void*)(&(s[stack_top].val)), (const void*)&bool_flag, STRING_LEN);
								s[stack_top].t = boolean;
								getchar();
								break;
							case 6:
								scanf("%c", &inbuf_char);
								memcpy((void*)(&(s[stack_top].val)), (const void*)&inbuf_char, STRING_LEN);
								s[stack_top].t = single_char;
								getchar();
								break;
						}
						break;
					case 21: 						// >>
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = (*(int*)&s[stack_top].val) >> (*(int*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = integer;
								break;
							case 3:
							case 4:
							case 5:
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 22:						// <<
						stack_top--;
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = (*(int*)&s[stack_top].val) << (*(int*)&s[stack_top + 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = integer;
								break;
							case 3:
							case 4:
							case 5:
							case 6:
								yyerror("Opration not support for this type of variabls.");
								break;
						}
						break;
					case 23:						// pop from the stack
						stack_top--;
						break;
					case 24:							// This == is especially for case, which will not pop the stack top after comparing
						switch (i.lev) {				// 2 opran should be with the same type
							case 2:
								outter_int = *(int*)&s[stack_top].val == *(int*)&s[stack_top - 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 3:
								outter_int = abs(*(float*)&s[stack_top].val - *(float*)&s[stack_top - 1].val) < FLOAT_EPS ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 4:
								outter_int = !strcmp(s[stack_top].val, s[stack_top - 1].val);
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 5:
								bool_opr1 = *(int*)&s[stack_top].val, bool_opr2 = *(int*)&s[stack_top - 1].val;
								outter_int = (bool_opr1 * bool_opr2 || (!bool_opr1 && !bool_opr2)) ? 1 : 0;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
							case 6:
								outter_int = *(char*)&s[stack_top].val == *(char*)&s[stack_top - 1].val;
								memcpy((void*)s[stack_top].val, (const void*)&outter_int, STRING_LEN);
								s[stack_top].t = boolean;
								break;
						}
						break;
				}
				break;
			case lod:
				input_flag = 1;
				stack_top++;
				addr = *(int*)&(i.opr);
				if (addr == -1) {

				}
				else {
					memcpy((void*)(&(s[stack_top].val)), (const void*)(&(s[addr].val)), STRING_LEN);
					switch (i.lev) {
						case 2:
							s[stack_top].t = integer;
							break;
						case 3:
							s[stack_top].t = real;
							break;
						case 4:
							s[stack_top].t = str;
							break;
						case 5:
							s[stack_top].t = boolean;
							break;
						case 6:
							s[stack_top].t = single_char;
							break;
					}
				}
				break;
			case sto:
				addr = *(int*)&(i.opr);
				memcpy((void*)(&(s[addr].val)), (const void*)(&(s[stack_top].val)), STRING_LEN);
				switch (i.lev) {
					case 2:
						s[stack_top].t = integer;
						break;
					case 3:
						s[stack_top].t = real;
						break;
					case 4:
						s[stack_top].t = str;
						break;
					case 5:
						s[stack_top].t = boolean;
						break;
					case 6:
						s[stack_top].t = single_char;
						break;
				}
				if (array_input == 1) {
					array_input = 0;
				}
				else {
					stack_top --;
				}
				break;
			case cal:
				break;
			case ini:
				stack_top = stack_top + *(int*)&i.opr;
				break;
			case jmp:
				pc = *(int*)&i.opr;
				break;
			case jpc:
				if (*(int*)&s[stack_top].val == 0) {		// jump when condition not true
					pc = *(int*)&i.opr;
				}
				stack_top--;
				break;
			case off:
				array_input = 1;
				res = 0;
				addr_to_find_array_in_table = *(int*)&i.opr;
				for (iter = 1; iter <= sym_tab_tail; iter++) {
					if (table[iter].addr == addr_to_find_array_in_table) {
						for (jter = 0; jter < MAX_ARR_DIM; jter++) {
							tmp_arr_list[jter] = table[iter].array_dim[jter];
						}
						break;
					}
				}
				for (iter = 0; iter < i.lev - 1; iter++) {
					res += (*(int*)&s[stack_top - (i.lev - iter - 1)].val) * tmp_arr_list[iter];
				}
				res += (*(int*)&s[stack_top].val);
				stack_top -= (i.lev);
				res += *(int*)&i.opr;
				//printf("res %d ", res);
				for (iter = pc; iter < vm_code_pointer; iter++) {
					if (code[iter].f == lod || code[iter].f == sto) {
						back_patch(iter, (byte*)res);
						break;
					}
				}
				// listall();
				// printf("=============================================================\n");
				break;
		}
		//print_data_stack();
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
		if (code[i].f == lit) {
			switch (code[i].lev) {
				case 2:
					printf("%4d %s %4d %4d\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)));
					fprintf(fcode, "%4d %s %4d %4d\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)));
					break;
				case 3:
					printf("%4d %s %4d %4f\n", i, name[code[i].f], code[i].lev, *(float*)(&(code[i].opr)));
					fprintf(fcode, "%4d %s %4d %4f\n", i, name[code[i].f], code[i].lev, *(float*)(&(code[i].opr)));
					break;
				case 4:
					printf("%4d %s %4d %s\n", i, name[code[i].f], code[i].lev, (code[i].opr));
					fprintf(fcode, "%4d %s %4d %s\n", i, name[code[i].f], code[i].lev, (code[i].opr));
					break;
				case 5:
					printf("%4d %s %4d %s\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)) == 1 ? "true" : "false");
					fprintf(fcode, "%4d %s %4d %s\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)) == 1 ? "true" : "false");
					break;
				case 6:
					printf("%4d %s %4d %4c\n", i, name[code[i].f], code[i].lev, *(char*)(&(code[i].opr)));
					fprintf(fcode, "%4d %s %4d %4c\n", i, name[code[i].f], code[i].lev, *(char*)(&(code[i].opr)));
					break;
			}
		}
		else {
			printf("%4d %s %4d %4d\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)));
			fprintf(fcode, "%4d %s %4d %4d\n", i, name[code[i].f], code[i].lev, *(int*)(&(code[i].opr)));
		}
	}
}

void print_data_stack() {
	int i = 3;
	for (; i <= stack_top; i++) {
		switch (s[i].t) {
			case integer:
				printf("%d\t\t%d\n", i, *(int*)&s[i].val);
				break;
			case real:
				printf("%d\t\t%f\n", i, *(float*)&s[i].val);
				break;
			case str:
				printf("%d\t\t%s\n", i, s[i].val);
				break;
			case boolean:
				printf("%d\t\t%s\n", i, *(int*)&s[i].val == 0 ? "false" : "true");
				break;
			case single_char:
				printf("%d\t\t%c\n", i, *(char*)&s[i].val);
				break;
		}
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
	display_sym_tab();
	listall();
	interpret();
	//listall();
	//print_data_stack();
}
