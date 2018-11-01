



table = fill(Any[],length(Productions),length(Tokens))



for prd=1:length(Productions)
	for tkn=1:length(Tokens)
		if contains(==,firsts[prd],tkn)
			table[prd,tkn] = vcat(table[prd,tkn],prd)	
		end		
	end

	if contains(==,follows[prd],EPISILON)

		for f in follows[prd]
			table[prd,f] = prd
		end
	end
end




