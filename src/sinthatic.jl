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


function getsubprod(prod_index::Int,fst::Int)
	subprods = grammar[prod_index][1]


	for sprod=1:length(subprods)	

		item = subprods[sprod][1]
		
		if typeof(item) == Int
			if item == fst
				return sprod
			else
				#faz nada
			end
		elseif typeof(item) == Symbol
			s = eval(item)
			if contains(==,firsts[s[2]],fst)
				return sprod
			end

		end


	end
	return false

end

function sinthatic()

	f = open(input,"r")
	count = 1
	curr_prod = Int(S_)
	for ln in eachline(f)

		@printf("%.4d    ",count)
		println(ln)

		tkn = ""
		while (tkn!="eol")
			tkn=nextToken()
			if tkn == "eol"
				break
			end			
			println(tkn)
			if contains(==,firsts[curr_prod],tkn.categ_num)
				println(grammar[curr_prod][1])
				println()
			end
		


		end
		println()
		count+=1
	end


end