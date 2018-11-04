
include("tokens.jl")
include("data_structures.jl")
grammar_map = Dict{Symbol,Int}()
grammar = []

function addProduction(id::Symbol,body_::Production)
	body = body_
	if !haskey(grammar_map,id)
		body.enum =length(grammar)+1
		body.lexem = string(id)
		push!(grammar, body)
		grammar_map[id] = length(grammar)	
	else
		error("Productions already exists")
	end
end
function addProduction(id::Symbol,body_)
	addProduction(id,Production(body_))
end
function addProd(id::Symbol,body_)
	addProduction(id,Production(body_))
end



function getProd(s::Union{Symbol,Int}) 
	 try
	 	return grammar[grammar_map[s]]
	 catch
	 	if isinteger(s)
	 	 	return grammar[s]
	 	else
	 	 	error("Wrong type input for getProd")
	 	 end
	 end
end

# ============================================================================================
# ============================================================================================
# ============================================================================================
# ============================================================================================
# ============================================================================================
# ==================== ISSO AQUI TUDO PODE SER APAGADO, É SÓ O EXEMPLO PRA EXPLICAR
info("Adcionando 3 produções aleatórias ATRIB CT_NUM E CU")

addProduction(:ATRIB,[[ID],[OPR_ATR],[CTN]])
addProduction(:CT_NUM,[[CTN],[CT_FLOAT]])
addProduction(:CU,[[:CT_NUM, CT_FLOAT, CTN]])

println("------------------3 produções foram adcionadas-------------------------")
info("Acessando uma produção usando o Número dela")
x=getProd(1)
println(x)
println("-----------------------------------------------")

info("Acessando essa mesma produção usando o ID dela")
x=getProd(:ATRIB)
println(x)

#Resetando o banco de produções
grammar_map = Dict{Symbol,Int}()
grammar = []



#=
	O PRÓXIMO PASSO é substituir as produções do formato confuso com vetor
	grammar = [ 
				ATRIB = [[[ID,OPR_ATR,CTN]],Int(ATRIB_)],
				CT_NUM = [[[CTN],[CT_FLOAT]],Int(CT_NUM_)]
				....]

	para o novo formato que usa a struct Production
	addProduction(:ATRIB,[[ID,OPR_ATR,CTN]])
	addProduction(:CT_NUM,[[CTN],[CT_FLOAT]])
	...
	
	---> Olhar o exemplo acima, dentro deste blocão de comentários

	--->USAR A GRAMÁTICA BOA! ESSA AQUI TÁ RUIM!!
=#




#=
	

	
	Usando addProduction não há a necessidade de atrelar manualmente o enumerador como é feito com ",Int(ATRIB_)" no modelo antigo
	
	A própria função faz esse mapeamento dentro do vetor grammar[] que associa números <---> Produçao
	A associação inversa Produção <----> Número é feita na própria produção no campo Production.enum
	Também é feita a associação Nome <----> Produçao no dicionário grammar_map

	Você pode acessar a produção com o Nome ou o número diretamente com a função getProd(S), onde s é um símbolo (nome) ou núermo da produçao

	ex: getProd(1) ----> retorna a produção com enum 1
		getProd(:FN_MAIN) ----> retorna a produção FN_MAIN

	------------------------------------------------------------------------
	A produção tem os seguintes campos.
	subprods é um vetor com o lado direito da produção 
	S -> ABC|CDE|xYZ
	subprods é [[A,B,C],[C,D,E].[x,Y,Z]]
	

	mutable struct Production
		subprods
		enum::Int
		firsts
		follows	
		lexem::String
	end

	Mains detalhes em data_structures.jl
	------------------------------------------------------------------------

=#
# ============================================================================================
# ============================================================================================
# ============================================================================================
# ============================================================================================
# ============================================================================================









# ISSO TUDO ABAIXO VAI SER DESCARTADO 


#=

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
=#