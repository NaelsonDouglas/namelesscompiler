tx =
SortedDict(
"CT_VALUE"=>1,
"CT_INT"=>2,
"CT_CHAR"=>3,
"CT_FLOAT"=>4,
"CT_VEC"=>5,
"SMCL"=>6,
"EPS"=>7,
"ID"=>8,
"CONST"=>9,
"EXPR"=>10,
"OPR_PM"=>11,
"OPR_DM"=>12,
"OPRLN"=>13,
"OPRLR_EQ"=>14,
"OPRLR_LG"=>15,
"OPRLR_LGEQ"=>16,
"FN_PRINT"=>17,
"FN_READ"=>18,
"DREAD"=>19,
"BLK_IF"=>20,
"BLK_ELS"=>21,
"BLK_FOR"=>22,
"BLK_WHILE"=>23,
"COMMA"=>24,
"O_BRCKT"=>25,
"C_BRCKT"=>26,
"O_C_BRCKT"=>27,
"C_C_BRCKT"=>28,
"O_PRTSIS"=>29,
"C_PRTSIS"=>30,
"OPR_ATR"=>31,
"IDT_INT"=>32,
"IDT_FLOAT"=>33,
"IDT_CHAR"=>34,
"IDT_STRING"=>35,
"FN_MAIN"=>36,
"VEC_IN"=>37,
"LEX_ERR"=>38,
"OPR_SUM"=>39,
"OPR_SUB"=>40,
"CTN"=>41,
"IDT_BOOL"=>42,
"EXP_BOOL"=>43,
"VOID"=>44,

"CT_STRING"=>45,
"OPR_CONCAT"=>46,
"OPR_UN_NEG"=>47,
"OPRLR_GT"=>48,
"RETURN"=>49,
"OPRLR_GEQ"=>50,
"OPRLR_LGEQ"=>51,
"OPR_CONCAT"=>52,
"OPRLR_AND"=>53,
"OPRLR_OR"=>54,
"OPRL_NOT"=>55,
"CTB"=>56,
"CMNT_LN"=>57,
"EPISILON"=>58,
"OPRLR_DIF"=>59,
"EOF"=>60
)





tx = String(JSON.json(tx))
f = open("tokens.json","w+")
write(f,tx)
flush(f)

#PARAMS"=>42,
#FN_CALL"=>46,

#https://github.com/JuliaLang/julia/blob/d386e40c17d43b79fc89d3e579fc04547241787c/base/Enums.jl#L31-L51