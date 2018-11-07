
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
                   [EOF],
                   [EPS]])

#=
   normal:
     TYPE  -> CONST 'int'
           -> CONST 'char'
           -> CONST 'float'
           -> CONST 'string'

     CONST -> 'const'
           -> EPS

   fectoring:
     TYPE  -> CONST TP

     CONST -> 'const'
           -> EPS

     TP    -> 'int'
           -> 'char'
           -> 'float'
           -> 'string'
=#
addProduction(:TYPE, [[:CONST_R, :TP]])
addProduction(:CONST_R, [[CONST],
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
           -> 'IDT_STRING' OPR_ATR EXPR_STRING
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> ID
           -> ID, VEC_IN, :EXPR_NUM

   factoring to remove ambiguity:

     ATTR  -> 'IDT_INT' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STRING
           -> 'IDT_CHAR' IDVEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' IDVEC OPR_ATR EXPR_NUM

     IDVEC -> 'id' IDT
     IDT   -> '::' EXPR_NUM | EPS
=#
addProduction(:ATTR, [[IDT_INT, :IDVEC, OPR_ATR, :EXPR_NUM],
                      [IDT_STRING, :IDVEC, OPR_ATR, :EXPR_STRING],
                      [IDT_FLOAT, :IDVEC, OPR_ATR, :EXPR_NUM],
                      [IDT_BOOL, :IDVEC, OPR_ATR, :EXPR_BOOL],
                      [IDT_CHAR, :IDVEC, OPR_ATR, :EXPR_NUM]])
addProduction(:IDVEC, [[ID, :IDT]])
addProduction(:IDT, [[VEC_IN, :EXPR_NUM],
                     [EPS]])

#=
normal:
   EXPR_STRING -> EXPR_STRING '+' EXPR_STRING
   EXPR_STRING -> (EXPR_STRING)
   EXPR_STRING -> 'ct_string'
   EXPR_STRING -> 'id'

factoring:
  EXPR_STRING -> ESH '+' EXPR_STRING

  ESH      -> 'ct_string'
           -> 'id'
           -> (EXPR_STRING)
=#
addProduction(:EXPR_STRING, [[:ESH, OPR_PM, :EXPR_STRING]])
addProduction(:ESH, [[CT_STRING],
                     [:FN_H_STR],
                     [O_BRCKT, :EXPR_STRING, C_BRCKT]])

addProduction(:FN_H_STR, [[ID, :FN_H_V_STR]])
addProduction(:FN_H_STR_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPS]])
#=
   normal:
     EXPR_NUM  -> EXPR_NUM + EXPR_NUM
               -> EXPR_NUM * EXPR_NUM
               -> '-' EXPR_NUM
               -> '(' EXPR_NUM ')'
               -> 'ct_int'
               -> 'ct_float'
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
   ambiguity:
     EXPR_NUM -> K KR
     KR       -> '+' EXPR_NUM
              -> EPS

     K        -> G KH

     KH       -> '*' G KH
              -> EPS

     G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
=#
addProduction(:EXPR_NUM, [[:K, :KR]])
addProduction(:KR, [[OPR_PM ,:EXPR_NUM],
                    [EPS]])
addProduction(:K, [[:G,:KH]])
addProduction(:KH, [[OPR_DM,:G, :KH],
                    [EPS]])
addProduction(:G, [[CT_FLOAT],
                   [CT_INT],
                   [ID],
                   [O_BRCKT, :EXPR_NUM, C_BRCKT]])

#addProduction(:FN_H_NUM, [[ID, :FN_H_V_NUM]])
#addProduction(:FN_H_NUM_V, [[VEC_IN, :EXPR_NUM],
#                            [:FN_CH],
#                            [EPS]])

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
                   [CT_INT, OPRLR_REL, :EXPR_NUM] ,
                   [CT_FLOAT, OPRLR_REL, :EXPR_NUM] ,
                   [:FN_H_BL, OPRLR_REL, :EXPR_NUM] ,
                   [CT_FALSE],
                   [CT_TRUE]])

addProduction(:FN_H_BL, [[ID, :FN_H_BL_V]])
addProduction(:FN_H_BL_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPS]])
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
                           [:RCONT, :ALL_INTER],
                           [:FN_CALL, :ALL_INTER],
                           [EPS]])

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
addProduction(:RIF1, [[BLK_ELS, :RIF2],
                      [EPS]])
addProduction(:RIF2, [[:RIF],
                      [O_C_BRCKT, :ALL_INTER, C_C_BRCKT]])
#=
   normal:
      RWHILE -> 'while' '(' EXPR_BOOL ')' '{' ALL_INTER '}'
=#
addProduction(:RWHILE, [[BLK_WHILE, O_BRCKT, :EXPR_BOOL, O_BRCKT, O_C_BRCKT,
                         :ALL_INTER, C_C_BRCKT]])

#=
  normal:
   RFOR   -> 'for' '(' ATTR_I ',' EXPR_NUM ',' EXPR_NUM ') '{' '{' ALL_INTER '}'
   ATTR_I -> 'int' 'id' '=' :EXPR_NUM
          -> 'id' ATTR_IH

  ATTR_IH -> '=' EXPR_NUM
          -> EPS
=#
addProduction(:RFOR, [[BLK_FOR, O_BRCKT, :ATTR_I , COMMA,:EXPR_NUM, COMMA,
                       :EXPR_NUM,C_BRCKT, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]])
addProduction(:ATTR_I, [[IDT_INT, ID, OPR_ATR, :EXPR_NUM],
                        [ID, :ATTR_IH]])
addProduction(:ATTR_IH, [[OPR_ATR, :EXPR_NUM],
                         [EPS]])
#=
   normal:
    RCONT -> 'continue'
          -> 'break'
          -> 'return' RH

   RH     -> EXPR_STRING
          -> EXPR_NUM
          -> EXPR_BOOL
          -> eps
=#
addProduction(:RCONT, [[CONTINUE], [BREAK], [RETURN]])
#addProduction(:RH, [#[:EXPR_STRING],
#                    [ID],
#                    [EPS]])
#=
addProduction(:FN_H_RET, [[ID, :FN_H_V_RET]])
addProduction(:FN_H_RET_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPS]])
=#

#=
  normal:
    FN_CALL -> 'id' FN_CH

    FN_CH   -> '(' FN_CHP

    FN_CHP  ->  FN_PR ')'
    FN_CHP  ->  ')'

    FN_PR   -> 'id' FN_PRE
            -> CN_TP FN_PRE

    FN_PRE  ->  ',' FN_PR
            ->  eps
    CN_TP -> 'ct_int'
          -> 'ct_float'
          -> 'ct_string'
          -> 'ct_bool'
=#
addProduction(:FN_CALL, [[ID, :FN_CH]])
addProduction(:FN_CH, [[O_BRCKT, :FN_CHP]])
addProduction(:FN_CHP, [[:FN_PR, C_BRCKT],
                        [C_BRCKT]])
addProduction(:FN_PR, [[ID, :FN_PRE],
                       [:CN_TP, :FN_PRE]])
addProduction(:FN_PRE, [[ID, COMMA, :FN_PR],
                        [EPS]])
addProduction(:CN_TP, [[CT_INT],
                       [CT_FLOAT],
                       [CT_STRING],
                       [CT_B]])
#=
normal:
EXPR    -> EPXR  '+'  EXPR
        -> EXPR  '*'  EXPR
        -> EXPR 'or'  EXPR
        -> EXPR 'and' EXPR
        -> EXPR 'rel' EXPR
        -> '(' EXPR ')'


precedence:
EXPR    -> EPXR_T  '+'  EXPR
        -> EXPR_T

EXPR_T  -> EXPR_T  '*'  EXPR_H
        -> EXPR_B

EXPR_B  -> EXPR_I 'or'  EXPR
        -> EXPR_I 'and' EXPR
        -> EXPR_I

EXPR_I  -> EXPR_I 'rel' EXPR_J
        -> EXPR_J

EXPR_J  -> CN_TP
        -> FN_CALL
        -> IDVEC
        -> '(' EXPR ')'

left recursion:

EXPR    -> EPXR_T  '+'  EXPR
        -> EXPR_T

EXPR_T  -> EXPR_H EXPR_TL

EXPR_TL -> '*' EXPR_B EXPR_TL
        -> 'eps'

EXPR_B  -> EXPR_I 'or'  EXPR
        -> EXPR_I 'and' EXPR
        -> EXPR_I

EXPR_I  -> EXPR_J EXPR_IL
EXPR_IL -> 'rel' EXPR EXPR_IL
        -> 'eps'

EXPR_J  -> CN_TP
        -> FN_CALL
        -> IDVEC
        -> '(' EXPR ')'

ambiguity:

EXPR    -> EPXR_T EXPRL

EXPRL   -> '+' EXPR
        -> 'eps'

EXPR_T  -> EXPR_H EXPR_TL

EXPR_TL -> '*' EXPR_B EXPR_TL
        -> 'eps'

EXPR_B  -> EXPR_I EXPR_BL

EXPR_BL -> 'or'  EXPR
        -> 'and' EXPR
        -> 'eps'

EXPR_I  -> EXPR_J EXPR_IL
EXPR_IL -> 'rel' EXPR EXPR_IL
        -> 'eps'

EXPR_J  -> CN_TP
        -> FN_CALL
        -> IDVEC
        -> '(' EXPR ')'


addProduction(:EXPR, [[:EXPR_T, :EXPRL]])
addProduction(:EXPRL, [[OPR_PM, :EXPR],
                       [EPS]])
addProduction(:EXPR_T, [[:EXPR_H, :EXPR_TL]])
addProduction(:EXPR_TL, [[OPR_DM, :EXPR_B, :EXPR_TL],
                         [EPS]])
addProduction(:EXPR_B, [[:EXPR_I, :EXPR_BL]])
addProduction(:EXPR_BL, [[OPRLR_OR, :EXPR],
                         [OPRLR_AND, :EXPR],
                         [EPS]])
addProduction(:EXPR_I, [[:EXPR_J, :EXPR_IL]])

addProduction(:EXPR_IL, [[OPRLR_REL, :EXPR_J, :EXPR_IL],
                         [EPS]])
addProduction(:EXPR_J, [[:CN_TP],
                        [:FN_H_EXPR],
                        [O_BRCKT, :EXPR, C_BRCKT]])

addProduction(:FN_H_EXPR, [[ID, :FN_H_EXPR_RET]])
addProduction(:FN_H_EXPR_V, [[VEC_IN, :EXPR_NUM],
                             [:FN_CH],
                             [EPS]])

=#
