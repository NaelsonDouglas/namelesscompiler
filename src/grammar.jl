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
    # error(string("The element ",id," is already defined"))
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
    S -> TYPE 'id' PARAM '{' ALL_ITER '}' S
      -> EPSILON
=#
addProduction(:S, [[:IDT_TYPE_OR_VOID,ID, :PARAM, O_C_BRCKT, :ALL_ITER, C_C_BRCKT, :S],
                   [EOF],
                   [EPSILON]])

#=
   normal:
     TYPE  -> CONST 'int'
           -> CONST 'char'
           -> CONST 'float'
           -> CONST 'string'

     CONST -> 'const'
           -> EPSILON

   fectoring:
     TYPE  -> CONST IDT_TYPE

     CONST -> 'const'
           -> EPSILON

     IDT_TYPE    -> 'int'
           -> 'char'
           -> 'float'
           -> 'string'
=#
addProduction(:TYPE, [[:CONST_R, :IDT_TYPE]])
addProduction(:CONST_R, [[CONST],
                         [EPSILON]])
addProduction(:IDT_TYPE, [[IDT_INT],
                    [IDT_CHAR],
                    [IDT_FLOAT],
                    [IDT_STRING],
                    [IDT_BOOL]])


addProduction(:IDT_TYPE_OR_VOID, [[:TYPE], [IDT_VOID]])

#=
   normal:
     PARAM  -> '(' ')'
            -> '(' PR ')'

     PR     -> TYPE ID_OR_VEC
            -> TYPE ID_OR_VEC ',' PR
   factoring to remove ambiguity:
     PARAM  -> '(' PRH

     PRH    -> ')'
            -> PR ')'

     PR     -> TYPE ID_OR_VEC PRL

     PRL    -> ',' PR
            -> EPSILON
=#
addProduction(:PARAM, [[O_BRCKT, :PRH]])
addProduction(:PRH, [[C_BRCKT],
                     [:PR, C_BRCKT]])
addProduction(:PR, [[:TYPE, :ID_OR_VEC, :PRL]])
addProduction(:PRL, [[COMMA, :PR],
                     [EPSILON]])

#=
   normal:
     ATTR  -> 'IDT_INT' ID_OR_VEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STRING
           -> 'IDT_CHAR' ID_OR_VEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' ID_OR_VEC OPR_ATR EXPR_NUM

     ID_OR_VEC -> ID
           -> ID, VEC_IN, :EXPR_NUM

   factoring to remove ambiguity:

     ATTR  -> 'IDT_INT' ID_OR_VEC OPR_ATR EXPR_NUM
           -> 'IDT_STRING' OPR_ATR EXPR_STRING
           -> 'IDT_CHAR' ID_OR_VEC OPR_ATR EXPR_NUM
           -> 'IDT_FLOAT' ID_OR_VEC OPR_ATR EXPR_NUM

     ID_OR_VEC -> 'id' IDT
     IDT   -> '::' EXPR_NUM | EPSILON
=#

#=
addProduction(:ATTR, [[IDT_INT, :ID_OR_VEC, OPR_ATR, :EXPR_NUM],
                      [IDT_STRING, :ID_OR_VEC, OPR_ATR, :EXPR_STRING],
                      [IDT_FLOAT, :ID_OR_VEC, OPR_ATR, :EXPR_NUM],
                      [IDT_BOOL, :ID_OR_VEC, OPR_ATR, :EXPR_BOOL],
                      [IDT_CHAR, :ID_OR_VEC, OPR_ATR, :EXPR_NUM]])
=#

addProduction(:IDT_T, [[IDT_CHAR],
                       [IDT_STRING],
                       [IDT_INT],
                       [IDT_FLOAT],
                       [IDT_BOOL],])

addProduction(:CT_BOOL, [[CT_TRUE],
                         [CT_FALSE]])

addProduction(:CT, [[CT_STRING],
                    [CT_FLOAT],
                    [CT_INT],
                    [:CT_BOOL]])


addProduction(:FCALL_OR_ATRIB, [[:ID_OR_VEC, :FCALL_OR_ATRIB_F]])


addProduction(:ATRIB, [[OPR_ATR, :EXPR_NUM]] )

addProduction(:FCALL_OR_ATRIB_F, [[:ATRIB],
                                   [:FN_CH]])


addProduction(:VAR_DCLR, [[:IDT_T, :ID_OR_VEC, OPR_ATR, :DATA]])

addProduction(:DATA, [[:CT],
                      [:ID_OR_VEC]])

addProduction(:ID_OR_VEC, [[ID, :VEC_INDX]])
addProduction(:INT_OR_ID, [[ID],
                           [CT_INT]])

addProduction(:VEC_INDX, [[VEC_IN, :INT_OR_ID],
                     [EPSILON]])

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

addProduction(:EXPR_STRING, [[:ESH, OPR_PM, :EXPR_STRING]])
addProduction(:ESH, [[CT_STRING],
                     [:FN_H_STR],
                     [O_BRCKT, :EXPR_STRING, C_BRCKT]])

addProduction(:FN_H_STR, [[ID, :FN_H_V_STR]])
addProduction(:FN_H_STR_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPSILON]])

   normal:
     EXPR_NUM  -> EXPR_NUM + EXPR_NUM
               -> EXPR_NUM * EXPR_NUM
               -> '-' EXPR_NUM
               -> '(' EXPR_NUM ')'
               -> 'ct_int'
               -> 'ct_float'
   precedence:
     EXPR_NUM -> EXPR_NUM_K
              -> EXPR_NUM_K + EXPR_NUM

     EXPR_NUM_K        -> EXPR_NUM_G
              -> EXPR_NUM_K * EXPR_NUM_G

     EXPR_NUM_G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
   removed left recursion:
     EXPR_NUM -> EXPR_NUM_K
              -> EXPR_NUM_K '+' EXPR_NUM

     EXPR_NUM_K        -> EXPR_NUM_G EXPR_NUM_KH

     EXPR_NUM_KH       -> '*' EXPR_NUM_G EXPR_NUM_KH
              -> EPSILON

     EXPR_NUM_G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
   ambiguity:
     EXPR_NUM -> EXPR_NUM_K EXPR_NUM_KR
     EXPR_NUM_KR       -> '+' EXPR_NUM
              -> EPSILON

     EXPR_NUM_K        -> EXPR_NUM_G EXPR_NUM_KH

     EXPR_NUM_KH       -> '*' EXPR_NUM_G EXPR_NUM_KH
              -> EPSILON

     EXPR_NUM_G        -> 'ct_int'
              -> 'ct_float'
              -> '(' EXPR_NUM ')'
=#

#=
addProduction(:NUM_OPRS, [[OPR_PM],
                          [OPR_DM]]
                           )



addProduction(:EXPR_NUM, [[O_C_BRCKT,:EXPR_NUM,C_C_BRCKT],
                          [:NUM_OPRS, :EXPR_NUM],
                          [:DATA, :EXPR_NUM],
                          [EPSILON]])



addProduction(:EXPR_NUM_R, [[:DATA, :NUM_OPRS, :EXPR_NUM_R]
                            [EPSILON]])
=#

addProduction(:EXPR_NUM, [[:EXPR_NUM_K, :EXPR_NUM_KR]])
addProduction(:EXPR_NUM_KR, [[OPR_PM ,:EXPR_NUM],
                    [EPSILON]])
addProduction(:EXPR_NUM_K, [[:EXPR_NUM_G,:EXPR_NUM_KH]])
addProduction(:EXPR_NUM_KH, [[OPR_DM,:EXPR_NUM_G, :EXPR_NUM_KH],
                    [EPSILON]])
addProduction(:EXPR_NUM_G, [[CT_FLOAT],
                   [CT_INT],
                   [:ID_OR_VEC],
                   [O_BRCKT, :EXPR_NUM, C_BRCKT]])


#addProduction(:FN_H_NUM, [[ID, :FN_H_V_NUM]])
#addProduction(:FN_H_NUM_V, [[VEC_IN, :EXPR_NUM],
#                            [:FN_CH],
#                            [EPSILON]])

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
     EXPR_BOOL -> EXPR_BOOL_T
               -> EXPR_BOOL 'or' EXPR_BOOL_T
               -> 'not' EXPR_BOOL_T

     EXPR_BOOL_T         -> EXPR_BOOL_F
               -> EXPR_BOOL_T 'and' EXPR_BOOL_F

     EXPR_BOOL_F         -> '(' EXPR_BOOL ')'
               -> EXPR_NUM 'rel' EXPR_NUM
               -> 'true'
               -> 'false'

   removed left recursion:
     EXPR_BOOL  -> EXPR_BOOL_T EXPR_BOOL_H
                -> 'not' EXPR_BOOL_T EXPR_BOOL_H

     EXPR_BOOL_H -> 'or' EXPR_BOOL_T EXPR_BOOL_H
                -> EPSILON

     EXPR_BOOL_T          -> EXPR_BOOL_F EXPR_BOOL_TH

     EXPR_BOOL_TH         -> 'and'EXPR_BOOL_F EXPR_BOOL_TH
                -> EPSILON

     EXPR_BOOL_F          -> '(' EXPR_BOOL ')'
                -> EXPR_NUM OPRLR_REL EXPR_NUM
                -> 'true'
                -> 'false'
=#
addProduction(:EXPR_BOOL, [[:EXPR_BOOL_T, :EXPR_BOOL_H],
                           [OPRL_NOT, :EXPR_BOOL_T, :EXPR_BOOL_H]])
addProduction(:EXPR_BOOL_H, [[OPRLR_OR, :EXPR_BOOL_T, :EXPR_BOOL_H],
                            [EPSILON]])

addProduction(:EXPR_BOOL_T, [[:EXPR_BOOL_F, :EXPR_BOOL_TH]])
addProduction(:EXPR_BOOL_TH, [[OPRLR_AND, :EXPR_BOOL_F, :EXPR_BOOL_TH],
                    [EPSILON]])
addProduction(:EXPR_BOOL_F, [[O_BRCKT, :EXPR_BOOL, C_BRCKT],
                   [CT_INT, :OPRLR_EQQ_REL , :EXPR_NUM] ,
                   [CT_FLOAT, :OPRLR_EQQ_REL , :EXPR_NUM] ,
                   [:FN_H_BOOL, :OPRLR_EQQ_REL , :EXPR_NUM] ,
                   [CT_FALSE],
                   [CT_TRUE]])

addProduction(:OPRLR_EQQ_REL , [[OPR_ATR, OPR_ATR],[OPRLR_REL]])

addProduction(:FN_H_BOOL, [[ID, :FN_H_BOOL_V]])
addProduction(:FN_H_BOOL_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPSILON]])
#=
   normal:
     ALL_ITER -> ITER_IF ALL_ITER
               -> ATTR ALL_ITER
               -> ITER_WHILE ALL_ITER
               -> ITER_FOR ALL_ITER
               -> ITER_CTRL ALL_ITER
=#
addProduction(:ALL_ITER, [[:ITER_IF, :ALL_ITER],
                           [:VAR_DCLR , :ALL_ITER],
                           [:ITER_WHILE, :ALL_ITER],
                           [:ITER_FOR, :ALL_ITER],
                           [:ITER_CTRL, :ALL_ITER],
                           [:FCALL_OR_ATRIB, :ALL_ITER],
                           [EPSILON]])

#=
   normal:
     ITER_IF  -> 'if' '(' EXPR_BOOL ')' '{' ALL_ITER '}' ITER_IF_R
     ITER_IF_R -> 'else' ITER_IF
          -> 'else' '{' ALL_ITER '}'
          -> EPSILON

   factoring:
     ITER_IF  -> 'if' '(' EXPR_BOOL ')' '{' ALL_ITER '}' ITER_IF_R

     ITER_IF_R -> 'else' ITER_IF_RR
          -> EPSILON

     ITER_IF_RR -> ITER_IF
          -> '{' ALL_ITER '}'
=#
addProduction(:ITER_IF,[[IF, O_BRCKT, :EXPR_BOOL, C_BRCKT,
                     O_C_BRCKT, :ALL_ITER,C_C_BRCKT, :ITER_IF_R]])
addProduction(:ITER_IF_R, [[ELSE, :ITER_IF_RR],
                      [EPSILON]])
addProduction(:ITER_IF_RR, [[:ITER_IF],
                      [O_C_BRCKT, :ALL_ITER, C_C_BRCKT]])
#=
   normal:
      ITER_WHILE -> 'while' '(' EXPR_BOOL ')' '{' ALL_ITER '}'
=#
addProduction(:ITER_WHILE, [[WHILE, O_BRCKT, :EXPR_BOOL, O_BRCKT, O_C_BRCKT,
                         :ALL_ITER, C_C_BRCKT]])

#=
  normal:
   ITER_FOR   -> 'for' '(' ATTR_I ',' EXPR_NUM ',' EXPR_NUM ') '{' '{' ALL_ITER '}'
   ATTR_I -> 'int' 'id' '=' :EXPR_NUM
          -> 'id' ATTR_IH

  ATTR_IH -> '=' EXPR_NUM
          -> EPSILON
=#
addProduction(:FOR_EXP_LIMITER,[[:ID_OR_VEC, :OPRLR_REL,:EXPR_NUM]])

addProduction(:ITER_FOR, [[FOR, O_BRCKT, :VAR_DCLR , COMMA,:FOR_EXP_LIMITER, COMMA,
                       :ID_OR_VEC, OPR_ATR, :EXPR_NUM,C_BRCKT, O_C_BRCKT, :ALL_ITER, C_C_BRCKT]])
addProduction(:ATTR_I, [[IDT_INT, ID, OPR_ATR, :EXPR_NUM],
                        [ID, :ATTR_IH]])
addProduction(:ATTR_IH, [[OPR_ATR, :EXPR_NUM],
                         [EPSILON]])
#=
   normal:
    ITER_CTRL -> 'continue'
          -> 'break'
          -> 'return' RH

   RH     -> EXPR_STRING
          -> EXPR_NUM
          -> EXPR_BOOL
          -> EPSILON
=#
addProduction(:ITER_CTRL, [[CONTINUE], [BREAK], [RETURN]])
#addProduction(:RH, [#[:EXPR_STRING],
#                    [ID],
#                    [EPSILON]])
#=
addProduction(:FN_H_RET, [[ID, :FN_H_V_RET]])
addProduction(:FN_H_RET_V, [[VEC_IN, :EXPR_NUM],
                            [:FN_CH],
                            [EPSILON]])
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
            ->  EPSILON
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
                        [EPSILON]])
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
        -> ID_OR_VEC
        -> '(' EXPR ')'

left recursion:

EXPR    -> EPXR_T  '+'  EXPR
        -> EXPR_T

EXPR_T  -> EXPR_H EXPR_TL

EXPR_TL -> '*' EXPR_B EXPR_TL
        -> 'EPSILON'

EXPR_B  -> EXPR_I 'or'  EXPR
        -> EXPR_I 'and' EXPR
        -> EXPR_I

EXPR_I  -> EXPR_J EXPR_IL
EXPR_IL -> 'rel' EXPR EXPR_IL
        -> 'EPSILON'

EXPR_J  -> CN_TP
        -> FN_CALL
        -> ID_OR_VEC
        -> '(' EXPR ')'

ambiguity:

EXPR    -> EPXR_T EXPRL

EXPRL   -> '+' EXPR
        -> 'EPSILON'

EXPR_T  -> EXPR_H EXPR_TL

EXPR_TL -> '*' EXPR_B EXPR_TL
        -> 'EPSILON'

EXPR_B  -> EXPR_I EXPR_BL

EXPR_BL -> 'or'  EXPR
        -> 'and' EXPR
        -> 'EPSILON'

EXPR_I  -> EXPR_J EXPR_IL
EXPR_IL -> 'rel' EXPR EXPR_IL
        -> 'EPSILON'

EXPR_J  -> CN_TP
        -> FN_CALL
        -> ID_OR_VEC
        -> '(' EXPR ')'


addProduction(:EXPR, [[:EXPR_T, :EXPRL]])
addProduction(:EXPRL, [[OPR_PM, :EXPR],
                       [EPSILON]])
addProduction(:EXPR_T, [[:EXPR_H, :EXPR_TL]])
addProduction(:EXPR_TL, [[OPR_DM, :EXPR_B, :EXPR_TL],
                         [EPSILON]])
addProduction(:EXPR_B, [[:EXPR_I, :EXPR_BL]])
addProduction(:EXPR_BL, [[OPRLR_OR, :EXPR],
                         [OPRLR_AND, :EXPR],
                         [EPSILON]])
addProduction(:EXPR_I, [[:EXPR_J, :EXPR_IL]])

addProduction(:EXPR_IL, [[OPRLR_REL, :EXPR_J, :EXPR_IL],
                         [EPSILON]])
addProduction(:EXPR_J, [[:CN_TP],
                        [:FN_H_EXPR],
                        [O_BRCKT, :EXPR, C_BRCKT]])

addProduction(:FN_H_EXPR, [[ID, :FN_H_EXPR_RET]])
addProduction(:FN_H_EXPR_V, [[VEC_IN, :EXPR_NUM],
                             [:FN_CH],
                             [EPSILON]])

=#
