grammar_file = "grammar_testing.jl"
include(grammar_file)


isSymbol(x) = typeof(x)==Symbol? true : false


"Gets the first on the head of the production
F = [[ABC]]
calcfst_head(F) will return the first of A
"
function calcfst_head(subproduction::Vector)	
	my_first = []


	try
		if isinteger(subproduction[1])  #IF the subproduction is a terminal
			push!(my_first,subproduction[1])
			return my_first
		end
	end

	try		
		if length(subproduction)==0 #If its an episilon subproduction
			push!(my_first,EPISILON)
			return my_first
		end
	end	

	if length(my_first) == 0
		return calcfst_head(eval(subproduction[1]))
	end
	return my_first
end


"Calcs the first for an entire production
F = [[ABC].[XYZ]]
calcfst_heart(F[1]) returns the first off ABC
"
function calcfst_heart(_production::Vector)
	my_first = []
	for p in _production
		@show p
		curr_fst = calcfst_head([p])
		push!(my_first,curr_fst)
		my_first = unique(collect(my_first))

		if !contains(==,curr_fst,EPISILON)
			break
		end
	end
	return my_first
end



function calc_first(productions::Vector)
	my_first = []
	for p in productions
		current_first = calcfst_heart(p)
		my_first = unique(vcat(my_first,current_first))
	end
	return my_first
end

















