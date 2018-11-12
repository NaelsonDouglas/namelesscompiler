input = "input/fib.nl"

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


include("tokens.jl")
include("data_structures.jl")
include("auxiliar_funcs.jl")
include("grammar.jl")



include("lexical.jl")
table = CSV.read("grammar_table.csv")

include("sinthatic.jl")

close(f)
close(tree_file)
close(g)

#Cria uma cópia da tabela LL1 na pasta especificações, onde o professor vai ver o que é pedido no arquivo
#Ocasionalmente esta tabela pode ser atualizada/melhorada. Por isso esse comando para sempre enviar ela para a pasta da avaliação
cp("grammar_table.csv","../especificações/tabela_LL1.csv",remove_destination=true)

#Converte a gramática da sintaxe usada na linguagem para a sintaxe vista em sala de aula 
convertGrammar()
