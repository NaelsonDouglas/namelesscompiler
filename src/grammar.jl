
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

   removed left recursion:
=#
addProduction(:S, [[:TYPE,ID, :PARAM, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]])

#=
   normal:

   removed left recursion:
=#
addProduction(:TYPE, [[IDT_INT],
                      [IDT_CHAR],
                      [IDT_FLOAT],
                      [IDT_STRING]])

#=
   normal:

   removed left recursion:
=#
addProduction(:PARAM, [[O_BRCKT, C_BRCKT],
                       [O_BRCKT, :P1, C_BRCKT]])
addProduction(:P1, [[:TYPE, :IDVEC],
                    [:TYPE, :IDVEC, COMMA, :P1]])

#=
   normal:
     ATTR  -> 'IDT_INT' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STR
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> ID
           -> ID, VEC_IN, :EXPR_NUM

   factor to remove ambiguity:

     ATTR  -> 'IDT_INT' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STR
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> ID
           -> ID, VEC_IN, :EXPR_NUM
=#
addProduction(:ATTR, [[:TYPE, :IDVEC, OPR_ATR, :EXPR_NUM],
                      [:TYPE, :IDVEC, OPR_ATR, CT_STRING]])
addProduction(:IDVEC, [[ID],
                       [ID, VEC_IN, :EXPR_NUM]])
#=
   normal:
     EXPR_NUM  -> EXPR_NUM + EXPR_NUM
               -> EXPR_NUM * EXPR_NUM
               -> '-' EXPR_NUM
               -> '(' EXPR_NUM ')'

   precedência:
     EXPR_NUM -> K
              -> K + EXPR_NUM

     K        -> G
              -> K * G

     G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
   removed left recursion:

=#
addProduction(:EXPR_NUM, [[:EX1],
                          [:EX1, OPR_PM ,:EXPR_NUM]])
addProduction(:EX1, [[:EX2,:EX11]])
addProduction(:EX11, [[OPR_DM,:EX2, :EX11],
                      [EPS]])
addProduction(:EX2, [[:IDVEC],
                     [CT_FLOAT],
                     [CT_INT],
                     [CT_STRING],
                     [O_BRCKT, :EX2, C_BRCKT]])


#=
   normal:
     EXPR_BOOL -> EXPR_BOOL 'or' EXPR_BOOL
               -> EXPR_BOOL 'and' EXPR_BOOL
               -> 'not' EXPR_BOOL
               -> '(' EXPR_BOOL ')'
               -> EXPR_NUM 'rel' EXPR_NUM
               -> 'true'
               -> 'false'
   precedência:
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
                -> EXPR_NUM 'rel' EXPR_NUM
                -> 'true'
                -> 'false'
=#
addProduction(:EXPR_BOOL, [[:T, :EXPR_BOOLH],
                           [OPRL_NOT, :T, :EXPR_BOOLH]])
addProduction(:EXPR_BOOLH, [[OPRL_OR, :T, :EXPR_BOOLH],
                            [EPS]])

addProduction(:T, [[:F, :TH]])
addProduction(:TH, [[OPRL_AND, :F, :TH],
                    [EPS]])

addProduction(:F, [[O_BRCKT, :EXPR_BOOL, C_BRCKT],
                   [:EXPR_NUM, :OPRL_REL, :EXPR_NUM] ,
                   [CT_FALSE],
                   [CT_TRUE]])

#=
   normal:

   removed left recursion:
=#
addProduction(:ALL_INTER, [[:RIF, :ALL_INTER],
                          [:ATTR , :ALL_INTER],
                          [:RWHILE, :ALL_INTER],
                          [:RFOR, :ALL_INTER],
                          [:RCONT, :ALL_INTER]])

#=
   normal:

   removed left recursion:
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
