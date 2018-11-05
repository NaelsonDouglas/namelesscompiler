
include("tokens.jl")
include("data_structures.jl")
grammar_map = Dict{Symbol,Int}()
grammar = Production[]

function addProduction(id::Symbol, body_::Production)
	body = body_
	if !haskey(grammar_map,id)
		#if !isdefined(id)
			body.enum =length(grammar)+1
			body.lexem = string(id)
			push!(grammar, body)
			grammar_map[id] = length(grammar)
		#else
		#	error(string("The element ",id," is already defined"))
		#end
	else
		error("Production already exists")
	end
end

function addProduction(id::Symbol,body_)
    addProduction(id,Production(body_))
end
function addProd(id::Symbol,body_)
    addProduction(id,Production(body_))
end


function getProd_idx(s::Union{Symbol,Int})
	 try
	 	return grammar[grammar_map[s]].enum
	 catch
    
	 	return false
	 end
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

#=
   normal:
    S -> TYPE 'id' PARAM '{' ALL_INTER '}' S
      -> EPS
=#
addProduction(:S, [[:RETYPE,ID, :PARAM, O_C_BRCKT, :ALL_INTER, C_C_BRCKT, :S],
                   [EPS]])

#=
   normal:
     TYPE  -> CONST 'int'
           -> CONST 'char'
           -> CONST 'float'
           -> CONST 'string'

     CONST -> 'const'
           -> EPS

     TP    ->
   fectoring:
     TYPE  -> CONST

     CONST -> 'const'
           -> EPS

     TP    -> 'int'
           -> 'char'
           -> 'float'
           -> 'string'
=#
addProduction(:TYPE, [[:CONST]])
addProduction(:CONST, [[CONST],
                       [EPS]])
addProduction(:TP, [[IDT_INT],
                      [IDT_CHAR],
                      [IDT_FLOAT],
                      [IDT_STRING],
                      [IDT_BOOL]])


addProduction(:RETYPE, [[:TYPE], [IDT_VOID]])

#=
   normal:
     PARAM  -> '(' ')'
            -> '(' PR ')'

     PR     -> TYPE IDVEC
            -> TYPE IDVEC ',' PR
   factoring to remove ambiguity:
     PARAM  -> '(' PRH

     PRH    -> ')'
            -> PR ')'

     PR     -> TYPE IDVEC PRL

     PRL    -> ',' PR
            -> EPS
=#
addProduction(:PARAM, [[O_BRCKT, :PRH]])
addProduction(:PRH, [[C_BRCKT],
                     [:PR, C_BRCKT]])
addProduction(:PR, [[:TYPE, :IDVEC, :PRL]])
addProduction(:PRL, [[COMMA, :PR],
                     [EPS]])

#=
   normal:
     ATTR  -> 'IDT_INT' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STR
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> ID
           -> ID, VEC_IN, :EXPR_NUM

   factoring to remove ambiguity:

     ATTR  -> 'IDT_INT' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STR
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> 'id' IDT
     IDT   -> '::' EXPR_NUM | EPS
=#
addProduction(:ATTR, [[IDT_INT, :IDVEC, OPR_ATR, :EXPR_NUM],
                      [IDT_STRING, :IDVEC, OPR_ATR, :EXPR_STR],
                      [IDT_FLOAT, :IDVEC, OPR_ATR, :EXPR_NUM],
                      [IDT_BOOL, :IDVEC, OPR_ATR, :EXPR_BOOL],
                      [IDT_CHAR, :IDVEC, OPR_ATR, :EXPR_NUM]])
addProduction(:IDVEC, [[ID, :IDT]]),
addProduction(:IDT, [[VEC_IN, :EXPR_NUM],
                     [EPS]])
#=
   normal:
     EXPR_NUM  -> EXPR_NUM + EXPR_NUM
               -> EXPR_NUM * EXPR_NUM 
               -> '-' EXPR_NUM
               -> '(' EXPR_NUM ')'

   precedence:
     EXPR_NUM -> K
              -> K + EXPR_NUM

     K        -> G
              -> K * G

     G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
   removed left recursion:
     EXPR_NUM -> K
              -> K '+' EXPR_NUM

     K        -> G KH

     KH       -> '*' G KH
              -> EPS

     G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
=#
addProduction(:EXPR_NUM, [[:K],
                          [:K, OPR_PM ,:EXPR_NUM]])

addProduction(:K, [[:G,:KH]])

addProduction(:KH, [[OPR_DM,:G, :KH],
                    [EPS]])

addProduction(:G, [[CT_FLOAT],
                   [CT_INT],
                   [O_BRCKT, :EXPR_NUM, C_BRCKT]])


#=
   normal:
     EXPR_BOOL -> EXPR_BOOL 'or' EXPR_BOOL
               -> EXPR_BOOL 'and' EXPR_BOOL
               -> 'not' EXPR_BOOL
               -> '(' EXPR_BOOL ')'
               -> EXPR_NUM 'rel' EXPR_NUM
               -> 'true'
               -> 'false'
   precedence:
     EXPR_BOOL -> T
               -> EXPR_BOOL 'or' T
               -> 'not' T

     T         -> F
               -> T 'and' F

     F         -> '(' EXPR_BOOL ')'
               -> EXPR_NUM 'rel' EXPR_NUM
               -> 'true'
               -> 'false'

   removed left recursion:
     EXPR_BOOL  -> T EXPR_BOOLH
                -> 'not' T EXPR_BOOLH

     EXPR_BOOLH -> 'or' T EXPR_BOOLH
                -> eps

     T          -> F TH

     TH         -> 'and'F TH
                -> eps

     F          -> '(' EXPR_BOOL ')'
                -> EXPR_NUM OPRLR_REL EXPR_NUM
                -> 'true'
                -> 'false'
=#
addProduction(:EXPR_BOOL, [[:T, :EXPR_BOOLH],
                           [OPRL_NOT, :T, :EXPR_BOOLH]])
addProduction(:EXPR_BOOLH, [[OPRLR_OR, :T, :EXPR_BOOLH],
                            [EPS]])

addProduction(:T, [[:F, :TH]])

addProduction(:TH, [[OPRLR_AND, :F, :TH],
                    [EPS]])

addProduction(:F, [[O_BRCKT, :EXPR_BOOL, C_BRCKT],
                   [:EXPR_NUM, :OPRLR_REL, :EXPR_NUM] ,
                   [CT_FALSE],
                   [CT_TRUE]])
addProduction(:OPRLR_REL, [[OPRLR_LGEQ]])

#=
   normal:
     ALL_INTER -> RIF ALL_INTER
               -> ATTR ALL_INTER
               -> RWHILE ALL_INTER
               -> RFOR ALL_INTER
               -> RCONT ALL_INTER
=#
addProduction(:ALL_INTER, [[:RIF, :ALL_INTER],
                          [:ATTR , :ALL_INTER],
                          [:RWHILE, :ALL_INTER],
                          [:RFOR, :ALL_INTER],
                          [:RCONT, :ALL_INTER]])

#=
   normal:
     RIF  -> 'if' '(' EXPR_BOOL ')' '{' ALL_INTER '}' RIF1
     RIF1 -> 'else' RIF
          -> 'else' '{' ALL_INTER '}'
          -> EPS

   factoring:
     RIF  -> 'if' '(' EXPR_BOOL ')' '{' ALL_INTER '}' RIF1

     RIF1 -> 'else' RIF2
          -> EPS

     RIF2 -> RIF
          -> '{' ALL_INTER '}'
=#
addProduction(:RIF,[[BLK_IF, O_BRCKT, :EXPR_BOOL, C_BRCKT,
                     O_C_BRCKT, :ALL_INTER,C_C_BRCKT, :RIF1]])
addProduction(:RIF1, [[BLK_ELS, :RIF1],
                      [BLK_ELS, O_C_BRCKT, :ALL_INTER, C_C_BRCKT],
                      [EPS]])

#=
   normal:
      
   removed left recursion:
=#
addProduction(:RWHILE, [[BLK_WHILE, O_BRCKT, :EXPR_BOOL, O_BRCKT, O_C_BRCKT,
                         :ALL_INTER, C_C_BRCKT]])

#=
   normal:

   removed left recursion:
=#
addProduction(:RFOR, [[BLK_FOR, O_BRCKT, :ATTR, COMMA,:EXPR_NUM, COMMA,
                       :EXPR_NUM,C_BRCKT, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]])

#=
   normal:

   removed left recursion:
=#
addProduction(:RCONT, [[CONTINUE], [BREAK], [RETURN], [RETURN, :EXPR_ALL]])
