Base.isinteger(v::Symbol) = false

amnt_productions = length(collect(map(Int,instances(Prods)))) #The amount of productions ---> The length of the Prods Enum
firsts = Vector{Vector}(amnt_productions)
fill!(firsts,Vector())
function calc_first(g=grammar)
	
	dependents = Vector{Vector}(amnt_productions)	
	fill!(dependents,Vector())

	
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
					if cell!=EPISILON
						break
					end
				elseif typeof(cell) == Symbol
					expanded = eval(cell)
					
					
					son_id = get_productionid(expanded)
					

					if length(firsts[son_id])>0

						firsts[prod_id]  = vcat(firsts[prod_id],firsts[son_id])
						break						
					else
						dependents[son_id] = vcat(dependents[prod_id],prod_id)
						dependents[son_id] = unique(dependents[son_id])
						firsts[prod_id]  = vcat(firsts[prod_id],cell)
					end				
				end
			end			

		end	


		
	end	
	#=
	println()	
	m = collect(instances(Prods))

	for i=1:length(dependents)
		println(m[i],"----",i,"----",dependents[i])
	end
	=#
end

"It's an auxiliar and ugly function. Nothing special to see here."
function reverse_first()
	names = collect(instances(Prods))
	for i=1:length(firsts)
		
		n = string(names[i])
		l = length(n)
		plus = 15-l
		
		l2 = length(string(i))
		plus2 = 4-l2
		print(i)
		for j=1:plus2
			print("-")
		end

		print(string(names[i]))
		for j=1:plus
			print("-")
		end
		println(firsts[i])
	end
end