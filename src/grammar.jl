
include("tokens.jl")
include("data_structures.jl")
grammar_map = Dict{Symbol,Int}()
grammar = []

function addProduction(id::Symbol, body_::Production)
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
  EXPR_STR -> EXPR_STR + EXPR_STR | CT_STR | IDVEC
=#
addProduction(:EXS2, [[:IDVEC],
                      [CT_STR]])
addProduction(:EXS1, [[OPR_PM,:EXS2, :EXS1],
                      [EPS]])
addProduction(:EXPR_STR, [[:EXS2, :EXS1]])


#=
   normal:

   removed left recursion:
=#
addProduction(:IDVEC, [[ID],
                       [ID, VEC_IN, :EXPR_NUM]])
addProduction(:ATTR, [[:TYPE, :IDVEC, EQ, :EXPR_NUM],
                      [:TYPE, :IDVEC, EQ, EXPR_STR]])

#=
   normal:

   removed left recursion:
=#
addProduction(:EXPR_ALL , [[:EXPR_NUM], [:EXPR_STR], [:EXPR_BOOL]])
addProduction(:EXPR_NUM, [[:EX1],
                          [:EX1, OPR_PM ,:EXPR_NUM]])
addProduction(:EX1, [[:EX2,:EX11]])
addProduction(:EX11, [[OPR_DM,:EX2, :EX11],
                      [EPS]])
addProduction(:EX2, [[:IDVEC],
                     [CT_FLOAT],
                     [CT_INT],
                     [O_BRCKT, :EX2, C_BRCKT]])


#=
   normal:

   removed left recursion:
=#
addProduction(:EXPR_BOOL, [[:EXB1],
                           [:EXB1, OPRLR_OR, :EXPR_BOOL]])
addProduction(:EXB1, [[:EXB1, :EXB11]])
addProduction(:EXB11, [[OPRLR_AND, :EXB2, :EXB11],
                       [EPS]])
addProduction(:EXB2, [[:IDVEC],
                      [C_BRCKT, :EXPR_BOOL, C_BRCKT] ,
                      [CT_INT]])

#=
   normal:

   removed left recursion:
=#
addProduction(ALL_INTER, [[:RIF, :ALL_INTER],
                          [ATTR , :ALL_INTER],
                          [:RWHILE, :ALL_INTER],
                          [:RFOR, :ALL_INTER],
                          [:RCONT, :ALL_INTER]])

#=
   normal:

   removed left recursion:
=#
addProduction(:RIF,[[BLK_IF, O_BRCKT, :EXPR_BOOL, C_BRCKT,
                     O_C_BRCKT, :ALL_INTER,C_C_BRCKT, :RIF1]])
addProduction(:RIF1, [[BLK_ELSE, :RIF1],
                      [BLK_ELSE, O_C_BRCKT, :ALL_INTER, C_C_BRCKT],
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
addProduction(:RFOR, [[BLK_FOR, O_BRCKT, ATTR, COMMA,:EXPR_NUM, COMMA,
                       :EXPR_NUM,C_BRCKT, O_C_BRCKT, :ALL_INTER, C_C_BRCKT]])

#=
   normal:

   removed left recursion:
=#
addProduction(:RCONT, [[CONTINUE], [BREAK], [RETURN], [RETURN, EXPR_ALL]])
