
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

function calc_first(productions::Vector)
	my_first = []
	for p in productions
		current_first = calcfst_heart(p)		
		my_first = vcat(my_first,plainvector(current_first))
		my_first = unique(collect(my_first))
	end
	
	my_first = plainvector(my_first)



	return my_first
end












