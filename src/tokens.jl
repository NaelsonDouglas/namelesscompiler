using DataStructures
using JSON


@enum Tokens CT_VALUE=1
CT_INT       # 123123
CT_CHAR      # 'c'
CT_FLOAT     # 123123.123123f
CT_VEC       # REMOVER
CT_STRING    # "LOLMEN"

SMCL         # ??
EPS          # EPSILON
ID           # 'id'
CONST        #  'const' possivelmente chamar de key_const
EXPR         # REMOVER

OPR_PM       # '+ -'
OPR_DM       # ' * /'

OPRLN        # ??
OPRLR_EQ     # REMOVER
OPRLR_LG     # REMOVER
OPRLR_LGEQ   # '== >= <= !='
OPR_ATR      # '='
OPRLR_UN_NEG # REMOVER
OPRLR_AND    # 'and'
OPRLR_OR     # 'or'
OPRL_NOT     # 'not'
FN_PRINT     # REMOVER
FN_READ      # REMOVER
DRED         # COMENTARIO ??

BLK_IF       # 'if'
BLK_ELS      # 'else'
BLK_FOR      # 'for'
BLK_WHILE    # 'while'

COMMA        # ','

O_BRCKT      # '('
C_BRCKT      # ')'
O_C_BRCKT    # '{'
C_C_BRCKT    # '}'
O_PRTSIS     # REMOVER
C_PRTSIS     # REMOVER

IDT_INT      # 'int'
IDT_FLOAT    # 'float'
IDT_CHAR     # 'char'
IDT_STRING   # 'string'
IDT_BOOL     # 'bool'
IDT_VOID     # 'void'
CT_FALSE     # 'false'
CT_TRUE      # 'true'

FN_MAIN      # REMOVER
VEC_IN       # '::'
LEX_ERR      # erro lexico
OPR_SUM      # REMOVER
OPR_SUB      # REMOVER
CTN          # REMOVER
PARAMS_Tk    # REMOVER
EXP_BOOL     # REMOVER

FN_DCLR      # REMOVER
FN_CALL_TK   # REMOVER
OPRLR_GT     # REMOVER
RETURN       # 'return'
OPRLR_GEQ    # REMOVER
OPR_CONCAT   # REMOVER
CTB          # COMENTARIO ??
CMNT_LN      # COMENTARIO DE LINHA ??
CONTINUE     # 'continue'
BREAK        # 'break'
OPRLR_DIF    # REMOVER
EOF


tks_names = String[]

for tk in instances(Tokens)
	push!(tks_names,string(tk))
end
