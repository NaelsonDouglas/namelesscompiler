S = [(DATA_TYPE FN_MAIN) (FN_DCLR DTA_TYPE FN_MAIN)]



DATA_TYPE -> "float" | "bool" | "char" | "string" | "void"

#TODO: Fatorar
FN_MAIN ->"main" "(" PARAMS ")" "{" CMD RETURN ID "}" | "main" "(" PARAMS ")" "{" "}"

#TODO: indecidibilidade
PARAMS -> ID|ID COMMA PARAMS|e

#TODO: Adcionar forma de CMD desencadear vários comandos ao invés de um único
# CMD -> CMD LOOP é recursovi à esquerda e CMD -> LOOP CMD vai gerar indecidibilidade com CMD -> LOOP
CMD -> LOOP | ATRIB | EXPR_ARIT | EXPR_BOOL | TERM


FN_DCLR -> DATA_TYPE ID"("PARAMS")""{"CMD RETURN DATA "}"


OPR_PM -> "+"|"-
OPR_DM -> "/"|*
OPRLR_EQ_DIF -> ==|!=
CHAR -> "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|"m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"x"|"y"|"w"|"z"|" "
ALPHA -> "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"


ALPHANUM -> CHAR ALPHA|ALPHA CHAR|ALPHA CHAR ALPHANUM|CHAR ALPHA ALPHANUM
#"TODO: indecisão
OPRLR_LGT -> "<"|"<="
OPRLR_GT -> ">"|">="


OPR_CONCAT -> "++"



COMMA -> ","
O_BRACKET -> "["
C_BRACKET -> "]"

OPRL_AND_OR -> "AND"|"OR"

OPR_NOT -> "NOT"

OPRLR -> OPRLR_EQ_DIF | OPRLR_LGT | OPRLR_LGT_EQ | ORPLR_AND_OR

CT_STRING -> """ALPHANUM"""
CT_INT -> OPR_PM NUM | NUM
CT_FLOAT -> CT_INT"." NUM
CTN -> CT_INT|CT_FLOAT

#TODO Indecidibilidade.
ID -> ALPHA NUM | ALPHA | ALPHA ID

LOOP_WHILE -> "while" "(" EXPR_BOOL ")" "{" CMD "}"

LOOP_FOR -> "for" "(" INT_DCLR COMMA EXPR_BOOL COMMA CMD ")" "{" CMD "}"

CTB -> NUM | "true" | "false"

EXPR_BOOL ->  EXPR_ARIT OPR_LOGIC EXPR_ARIT | CTB

TERM -> CTN|ID

#TODO: Recursão à esquerda
EXPR_ARIT ->  TERM OPR_ALGEBC TERM | EXPR_ARIT "(" OPR_ALGEBC EXPR_ARIT ")"

DATA -> EXPR_ARIT | TERM | EXPR_BOOL
ATRIB -> ID "=" DATA
VAR_DCLR -> DATA_TYPE ATRIB

FN_CALL -> ID "(" PARAMS ")"

#TODO: Indecidibilidade
COMMENT_BLOCK -> "\*"CT_STRING"\*"/ | "/*" COMMENT_BLOCK "\*"

BREAKER -> "\n"| EOF
COMENT_LINE -> "#" CT_STRING BREAKER
COMMENT -> COMMENT_BLOCK | COMMENT_LINE
