
function addProduction(prd::Production,grammar_=grammar)
	prd
	push!(grammar_, prd)
end


grammar =
[

ATRIB = [[[ID,OPR_ATR,CTN]],Int(ATRIB_)],
CT_NUM = [[[CTN],[CT_FLOAT]],Int(CT_NUM_)],
OPR_ARIT = [[[OPR_DM],[OPR_SUM],[OPR_SUB]],Int(OPR_ARIT_)],
OPR_SUMSUB = [[[OPR_SUM],[OPR_SUB]],Int(OPR_SUMSUB_)],
OPRLR_EQ_DIF = [[[OPRLR_EQ],[OPRLR_DIF]],Int(OPRLR_EQ_DIF_)],
OPRLR_LGTR = [[[OPR_ATR],[EPISILON]],Int(OPRLR_LGTR_)],
OPRLR_GTR = [[[OPR_ATR],[EPISILON]],Int(OPRLR_GTR_)],
OPRL_ANDOR = [[[OPRLR_OR],[OPRLR_AND]],Int(OPRL_ANDOR_)],
BOOLEAN = [[[CTB],[CTN]],Int(BOOLEAN_)],

INT_DCLR = [[[IDT_INT,OPR_ATR,CT_INT]],Int(INT_DCLR_)],
EXPR_ARIT = [[[CTN,:OPR_ARIT,CTN]],Int(EXPR_ARIT_)],
OPR_LOGIC = [[[:OPR_ARIT]],Int(OPR_LOGIC_)], #Todo: escrever os operadores lógicos
EXPR_BOOL = [[[:EXPR_ARIT,:OPR_LOGIC,:EXPR_ARIT,CTB]],Int(EXPR_BOOL_)],
LOOP_WHILE = [[[BLK_WHILE, O_BRCKT, :EXPR_BOOL, C_BRCKT, O_C_BRCKT, C_C_BRCKT]],Int(LOOP_WHILE_)],
LOOP_FOR = [[[BLK_FOR, O_C_BRCKT, :INT_DCLR, COMMA, :EXPR_BOOL, COMMA, C_C_BRCKT, O_C_BRCKT, C_C_BRCKT]],Int(LOOP_FOR_)],
LOOP = [[[:LOOP_FOR],[:LOOP_WHILE]],Int(LOOP_)],
#TODO: Adcionar uma forma de CMD desencadear vários comandos ao invés de um único
CMD = [[[:LOOP], [:ATRIB] , [:EXPR_ARIT] , [:EXPR_BOOL]],Int(CMD_)],
DATA_TYPE = [[[IDT_FLOAT],[IDT_INT], [IDT_BOOL], [IDT_CHAR], [IDT_STRING], [VOID], [:CMD]],Int(DATA_TYPE_)],
PARAMS_R = [[[COMMA,:DATA_TYPE,ID,:PARAMS_R],[EPISILON]],Int(PARAMS_R_)],
PARAMS = [[[:DATA_TYPE,ID,:PARAMS_R],[EPISILON]],Int(PARAMS_)],
MAIN = [[[FN_MAIN,O_BRCKT,:PARAMS,C_BRCKT,O_C_BRCKT, :CMD,C_C_BRCKT]],Int(MAIN_)],
FN_DCLR = [[[:DATA_TYPE,ID,O_BRCKT,PARAMS,C_BRCKT,O_C_BRCKT,:CMD,C_C_BRCKT]],Int(FN_DCLR_)],
S = [[[:MAIN],[:FN_DCLR,:MAIN]],Int(S_)],
TERM_NUM = [[[:CT_NUM],[ID]],Int(TERM_NUM_)],
EXP_ARIT = [[[:CT_NUM,:OPR_ARIT,:CT_NUM],[OPR_SUB,:CT_NUM,:OPR_ARIT,:CT_NUM],[O_BRCKT,:EXPR_ARIT,C_BRCKT]],Int(EXP_ARIT_)],
EXPR_ALG = [[[:EXPR_ARIT],[:TERM_NUM, :OPR_ARIT, :EXPR_ALG]],Int(EXPR_ALG_)],
OPRLR_LGT = [[[OPRLR_LG,:OPRLR_LGTR]],Int(OPRLR_LGT_)],
OPRLR_G = [[[OPRLR_GT,:OPRLR_GTR]],Int(OPRLR_G_)],
OPRLR = [[[:OPRLR_LGT],[OPRLR_GT],[OPRLR_EQ]],Int(OPRLR_)],
FN_CALL = [[[ID,O_BRCKT, :PARAMS,C_BRCKT]],Int(FN_CALL_)],
]