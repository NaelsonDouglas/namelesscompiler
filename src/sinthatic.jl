
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
	
	
	q = Queue(Any)
	enqueue!(q,:S)

	for ln in eachline(f)

		@printf("%.4d    ",count)
		println(ln)

		tkn = ""
		while (tkn!="eol")

			
			tkn = nextToken()
			if tkn == "eol"
				break
			end			
			println(tkn)

			queue_top = front(q)
			subprod = getsubprod(queue_top,tkn.categ_num)

			if typeof(queue_top[1][subprod]) == Int #If it's a token

			end





		end		

		println()
		count+=1
	end


end