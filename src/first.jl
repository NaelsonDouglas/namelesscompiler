Base.isinteger(v::Symbol) = false

amnt_productions = length(collect(map(Int,instances(Prods)))) #The amount of productions ---> The length of the Prods Enum
firsts = Vector{Vector}(amnt_productions)
fill!(firsts,Vector())
function calc_first(g=grammar)
	
	for prod_i in g #Individual productionsi in the grammar
		prods_body   = get_productions(prod_i)
		prod_id      = get_productionid(prod_i)		
		
		for sent in prods_body # Right-sides
			#@show prods_body
			#@show sent
			#@show prod_id						
			for cell in sent
				if typeof(cell) == Int
					firsts[prod_id]  = vcat(firsts[prod_id],cell)
					break
				elseif typeof(cell) == Symbol
					expanded = eval(cell)
					
				end
			end			
			
		end	
		


	end	
end