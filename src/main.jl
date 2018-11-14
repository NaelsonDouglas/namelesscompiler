input = "input/shell_sort.nl"
manual = false #If it's true, all the steps on the analysis will require the user to press enter. Otherwise, it will be executed automatically

input_name = split(split(input,"/")[2],".")[1] #The name without the '.nl' and without the directory
tree_file = open("../outputs/tree/$input_name","w+")


if !isdefined(:already_executed_flag) #Only calls the includes if it's the first time you call include("main.jl")
	try		
		info("Loading the needed packages. Since it's the first execution of the code for this workspace, it may take some seconds.")
		info("On the next time you call call include(\"main.jl\"), it will be faster since the packages will not be loaded again.")
		
		using CSV
		#using DataStructures
		using DataFrames
		using JSON
		using Match
	catch
		info("Installing missing packages. It may take some minutes depending on your internet connection.")
		Pkg.add("CSV")
		#Pkg.add("DataStructures")
		Pkg.add("DataFrames")
		Pkg.add("JSON")
		Pkg.add("Match")

		using CSV
		#using DataStructures
		using JSON
		using Match
	end		
end	
already_executed_flag =  true


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
#convertGrammar()