
grammar_file = "grammar.jl"



amnt_productions = length(collect(map(Int,instances(Prods)))) #The amount of productions ---> The length of the Prods Enum
firsts = fill([],amnt_productions)


include(grammar_file)
include("auxiliar_funcs.jl")

#isSymbol(x) = typeof(x)==Symbol? true : false


Base.isinteger(v::Symbol) = false


function calc_first(productions::Vector)
	
	my_first = []
	
	return my_first
end












