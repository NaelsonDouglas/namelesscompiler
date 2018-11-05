include("grammar.jl")
include("first.jl")
map(calc_first,grammar)

function isProduction(p)
	# if we just do return typeof(p) == Symbol it might bug when p is an Enum
	#Dont aske me why
	if typeof(p) == Symbol
		return true
	end

	return false
end

function calc_follow(p::Union{Production,Int})
	subprods = -1
	
	if typeof(p) == Int
		subprods = getProd(p).subprods
	else
		subprods = p.subprods
	end


	for sprod in subprods
		for elemsprod_idx=1:(length(sprod)-1)
			

			if isProduction(sprod[elemsprod_idx]) #Symbols are non-terminals. Enums are tokens			
				father_id=getProd_idx(sprod[elemsprod_idx])
				if isProduction(sprod[elemsprod_idx+1])

					for fst in getProd(elemsprod_idx+1).firsts
						@show sprod[elemsprod_idx]
						#println("----")
						grammar[father_id].follows = 
														unique(vcat(grammar[father_id].follows,fst))
					end
				else
					nxtToken = Int(sprod[elemsprod_idx+1])
					if nxtToken != Int(EPS)							
						grammar[father_id].follows = unique(vcat(grammar[father_id].follows,nxtToken))
					end
				end
				
			else
				#If it's not a symbol, then it's a token, alas, there's no follows for it
			end

		end

		if typeof(last(sprod)) == Symbol
			son_id = getProd_idx(last(sprod))
			father_id = p.enum
			#@show p
			for fl in grammar[father_id].follows
				grammar[son_id].follows =
											 unique(vcat(grammar[son_id].follows,fl))
			end
		end
	end

end


map(calc_follow,grammar)



