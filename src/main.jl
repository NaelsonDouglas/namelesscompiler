input = "input/hello_world.nl"

try
	using CSV
	using DataStructures
	#using DataFrames
	using JSON
	using Match
catch
	Pkg.add("CSV")
	Pkg.add("DataStructures")
	Pkg.add("DataFrames")
	Pkg.add("JSON")
	Pkg.add("Match")

	using CSV
	#using DataStructures
	using JSON
	using Match
end

include("auxiliar_funcs.jl")
include("tokens.jl")
include("data_structures.jl")
include("grammar.jl")
include("lexical.jl")

table = CSV.read("grammar_table.csv")

include("sinthatic.jl")

#println(steps)

#info("Chama a variável steps se quiser ver os passos do analisador")