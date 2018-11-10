input = "input/hello_world.nl"

input_name = split(split(input,"/")[2],".")[1] #The name without the '.nl' and without the directory
tree_file = open("../outputs/tree/$input_name","w+")

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

close(f)
close(tree_file)
close(g)


#println(steps)

#info("Chama a variável steps se quiser ver os passos do analisador")