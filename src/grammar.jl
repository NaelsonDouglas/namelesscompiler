#Isso tudo é um vetor
productions =
[
S = [[:MAIN],[:FN_DCLR,:MAIN]],

MAIN = [[:DATA_TYPE,:FN_MAIN,:O_BRCKT,:PARAMS,:C_BRCKT,:O_C_BRCKT, :CMD,:C_C_BRCKT]],

DATA_TYPE = [[IDT_FLOAT]; [IDT_BOOL]; [IDT_CHAR]; [IDT_STRING]; [VOID];[:CMD]],

FN_DCLR = [[DATA_TYPE,ID,O_BRCKT,PARAMS,C_BRCKT,O_C_BRCKT,:CMD,C_C_BRCKT]],

#TODO: Adcionar uma forma de CMD desencadear vários comandos ao invés de um único
# CMD -> CMD LOOP é recursivo à esquerda e CMD -> LOOP CMD vai gerar indecidibilidade com CMD -> LOOP
CMD = [[:LOOP], [:ATRIB] , [:EXPR_ARIT] , [:EXPR_BOOL]],

ATRIB = [[ID OPR_ATR CTN]],

INT_DCLR = [[IDT_INT OPR_ATR CT_INT]],

LOOP_WHILE = [[:BLK_WHILE, O_BRCKT, :EXPR_BOOL, C_BRCKT, O_C_BRCKT, :CMD, C_C_BRCKT]],
LOOP_FOR = [[:BLK_FOR, O_C_BRCKT, INT_DCLR, COMMA, :EXPR_BOOL, COMMA, :CMD, C_C_BRCKT, O_C_BRCKT, :CMD, C_C_BRCKT]],
LOOP = [[:LOOP_FOR],[:LOOP_WHILE]],


#TODO: Expandir definição
EXPR_ARIT = [[CTN,:OPR_ARIT,:CTN]],
EXPR_BOOL = [:EXPR_ARIT,:OPR_LOGIC,:EXPR_ARIT,:CTB],


CT_NUM = [[CTN],[CT_FLOAT]],
TERM_NUM = [[CT_NUM],[ID]],

#Todo: expandir operações com chaves
EXP_ARIT = [[:CT_NUM,:OPR_ARIT,:CT_NUM],[:OPR_SUB,:CT_NUM,:OPR_ARIT,:CT_NUM],[O_BRCKT,:EXPR_ARIT,C_BRCKT]],

#TODO: Expandir chaves
OPR_ARIT = [[OPR_DM],[OPR_SUM],[OPR_SUB]],
EXPR_ALG =  [[:EXPR_ARIT],[:TER_NUM, :OPR_ARIT, :EXPR_ALG]],

#CHAR = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","w","z"," "],
#NUM = ["0","1","2","3","4","5","6","7","8","9"],

PARAMS = [[DATA_TYPE,ID,:PARAMS_R],[EPISILON]],
PARAMS_R = [[COMMA,:DATA_TYPE,:ID,:PARAMS_R],[EPISILON]],

OPR_SUMSUB = [[OPR_SUM],[OPR_SUB]],
OPRLR_EQ_DIF = [[OPRLR_EQ],[OPRLR_DIF]],

OPRLR_LGT = [[OPRLR_LG,:OPRLR_LGTR]],
OPRLR_LGTR = [[OPR_ATR],[EPISILON]],

OPRLR_GT = [[">",:OPRLR_GTR]],
OPRLR_GTR= [[OPR_ATR],[EPISILON]],

OPRLR = [[:OPRLR_LGT],[:OPRLR_GT],[OPRLR_EQ]],

OPRL_ANDOR = [[OPRLR_OR],[OPRLR_AND]],

BOOLEAN = [[CTB],[CTN]],


FN_CALL = [[ID,O_BRCKT, :PARAMS,C_BRCKT]]

]

