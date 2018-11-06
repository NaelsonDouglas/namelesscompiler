input = "input/fib.nl"

try
	using DataStructures
	using JSON
	using Match
catch
	Pkg.add("DataStructures")
	Pkg.add("JSON")
	Pkg.add("Match")
	using DataStructures
	using JSON
	using Match
end

include("auxiliar_funcs.jl")
include("tokens.jl")
include("data_structures.jl")
include("grammar.jl")
include("lexical.jl")
include("first.jl")
#include("follow.jl") Calculamos manualmente


map(calc_first,grammar)