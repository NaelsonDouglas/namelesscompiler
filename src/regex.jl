
opr_pm = [+|-]
opr_dm = [/|*]

oprlr_eq_dif = [==|!=]
oprlr_lgt = [<|>]
oprlr_lgt_eq = [<=|>=]

oprl_algebc = {oprlr_eq_dif} | {oprlr_lgt} | {oprlr_lgt_eq}
opr_algebc = opr_pm | opr_dm

oprl_and_or = [:blank:]+"and"[:blank:]+ | [:blank:]+"or"[:blank:]+
opr_not = "not"[:blank:]*



oprlr = {oprlr_eq_dif} | {oprlr_lgt} | {oprlr_lgt_eq} | {orplr_and_or}



ct_str = "\"".*"\""$
ct_int = ^{opr_pm}?[0-9]+$
ct_float = {ct_int}[.][0-9]*$
id = ^[:alpha:]+[:alnum:]*


loop_while = "while" [:blank:]+"("{expr_bool}")"[:blank:]+ "{"{cmd}"}"
loop_for = "for"[:blank:]+"("{int_dclr}{comma}{ct_int}{comma}{ct_int}")"[:blank:]*"{"{cmd}"}"
ctb = "1" | "0" | "true" | "false"
expr_bool =  {expr_arit} {opr_logic} {expr_arit} | {ctb}


ctn = {ct_int}|{ct_float}
term = {ctn}|{id}

expr_arit =  {term} {opr_algebc} {term} | "(" {expr_arit} [{opr_algebc}{expr_arit}]*")"[{opr_algebc}{expr_arit}]*
data = {expr_arit} | {term} | {ct_float} | {ct_int} | {expr_bool}
int_dclr = "int" {id} "=" [0-9]*

float_type = "float"
bool_type = "bool"
char_type = "char"
string_type = "string"

var_dclr = {int_dclr} | [{bool_type} | {float_type} | {char_type} | {string_type}] {atrib}]
atrib = {id} "=" {data}
cmd = {loop} | {atrib} | {expr_arit} | {expr_bool} | {term}

params = {id}|{id}{comma}{id}?[{comma}{params}]
func_call = {id}"("?{params}")"


comment_block = "/*"[:alnum:]*"*/" | "/*"{comment_block}"*/"
coment_line = "//"[:alnum:]*
comment = comment_block | comment_line

comma = ","
o_bracket = ["["]
c_bracket = ["]"]
	
	



#TODO
Comandos, loops, chamadas de função



function reg_tostring(r::Regex)
  regx = string(r)
  return regx[3:length(regx)-1]
end