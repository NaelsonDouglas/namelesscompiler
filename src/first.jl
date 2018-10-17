
grammar_file = "grammar.jl"


include(grammar_file)
include("auxiliar_funcs.jl")

#isSymbol(x) = typeof(x)==Symbol? true : false



"Gets the first on the head of the production
F = [[ABC]]
calcfst_head(F) will return the first of A
"
function calcfst_head(subproduction::Union{Vector,Int})	
	my_first = []


	try
		if isinteger(subproduction[1])  #IF the subproduction is a terminal
			push!(my_first,subproduction[1])
			return plainvector(my_first)
		end
	end

	try		
		if length(subproduction)==0 #If its an episilon subproduction
			push!(my_first,EPISILON)
			return plainvector(my_first)
		end
	end	

	if length(my_first) == 0

		return calcfst_head(eval(subproduction[1]))
	end
	return plainvector(my_first)
end


"Calcs the first for an entire production
F = [[ABC].[XYZ]]
calcfst_heart(F[1]) returns the first off ABC
"
function calcfst_heart(production::Union{Vector,Symbol,Int})
	my_first = []

	
	
	_production = production
	if typeof(_production) == Symbol
		_production = eval(_production)
	end	

	for p in _production		

		curr_fst = plainvector(calcfst_head([p]))
		push!(my_first,curr_fst)
		my_first = unique(collect(my_first))

		
	end

	if (contains(==,my_first,EPISILON) && (length(my_first)>1))
			filter!(my_first) do x
				x!=EPISILON
			end
	end

	
	return collect(plainvector(my_first))

end


Base.isinteger(v::Symbol) = false

function getfst_sentence(sentence::Union{Int,Symbol})
	if isinteger(sentence)
		return sentence
	else
		return eval(sentence)
	end


end

function calc_first(productions::Vector)
	my_first = []
	#a sentene in each proudction S -> AB | CD
	#AB and CD are productions,A,B,C,D are sentences
	for p in productions
		
		println("---------------------")
		@show productions


		#This loop  test to prevent the usage of bad written grammars
		for pi in p
			try
				if (typeof(pi) != Symbol && typeof(pi)!= Int)
					@show p[1]
					@show pi 
					error("Irregular grammar definition")
					exit(0)
				end
			catch
				println("---------------------")
				@show productions
				@show p
				@show pi
				println("---------------------")
				error("pi should be of the type Symbol or Int, but I got an ",typeof(pi))
			end

		end

		@show p
		for sent_i=1:length(p)
			
			@show p[sent_i]
			println()
		end


	end
	
	



	return my_first
end












