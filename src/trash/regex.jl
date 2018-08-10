opr_pm = [+|-]
opr_dm = [/|*]



oprlr_eq_dif = [==|!=]
oprlr_lgt = [<|>]
oprlr_lgt_eq = [<=|>=]

comma = ","
o_bracket = ["["]
c_bracket = ["]"]

oprl_algebc = {oprlr_eq_dif} | {oprlr_lgt} | {oprlr_lgt_eq}
opr_algebc = opr_pm | opr_dm

oprl_and_or = [:blank:]+"and"[:blank:]+ | [:blank:]+"or"[:blank:]+
opr_not = "not"[:blank:]*

oprlr = {oprlr_eq_dif} | {oprlr_lgt} | {oprlr_lgt_eq} | {orplr_and_or}

opr_concat = "++"+ 
ct_str = "\"".*"\""?[{opr_concat}{ct_string}?{ct_str}]

ct_int = ^{opr_pm}?[0-9]+$
ct_float = {ct_int}[.][0-9]*$
ctn = {ct_int}|{ct_float}
id = ^[:alpha:]+[:alnum:]*

loop_while = "while" [:blank:]+"("{expr_bool}")"[:blank:]+ "{"{cmd}"}"
loop_for = "for"[:blank:]+"("{int_'dclr'}{comma}{ct_int}{comma}{ct_int}")"[:blank:]*"{"{cmd}"}"
ctb = "1" | "0" | "true" | "false"
expr_bool =  {expr_arit} {opr_logic} {expr_arit} | {ctb}



term = {ctn}|{id}

expr_arit =  {term} {opr_algebc} {term} | "(" {expr_arit} [{opr_algebc}{expr_arit}]*")"[{opr_algebc}{expr_arit}]*
data = {expr_arit} | {term} | {expr_bool}
int_dclr = "int" {id} "=" [0-9]*

float_type = "float"
bool_type = "bool"
char_type = "char"
string_type = "string"
void_type = "void"

data_type = {float_type} | {bool_type} | {char_type} | {string_type} | {void}

var_dclr = {int_dclr} | [{bool_type} | {float_type} | {char_type} | {string_type}] {atrib}]
atrib = {id} "=" {data}
cmd = {loop} | {atrib} | {expr_arit} | {expr_bool} | {term}

params = {id}|{id}{comma}{id}?[{comma}{params}]
fn_dclr = {data_type} {id}"("{params}")"[:blank:]*"{"{cmd}*?["return" {data}]"}"
fn_call = {id}"("?{params}")"

comment_block = "/*"[:alnum:]*"*/" | "/*"{comment_block}"*/"
coment_line = "//"[:alnum:]*
comment = comment_block | comment_line