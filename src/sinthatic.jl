
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
	
	
	st = Stack(Any)
	push!(st,S[1])
	topid = S[2]

	tkn = nextToken()

	for ln in eachline(f)

		@printf("%.4d    ",count)
		println(ln)

		
		while (tkn!="eol")

			
			
			if tkn == "eol"
				break
			end
			

			stack_top = top(st)		

			subprod_i = getsubprod(topid,tkn.categ_num)

			@show tkn
			@show stack_top
			@show subprod_i
			@show topid
			@show tkn.categ_num
			println()

			prd = stack_top[subprod_i]
			
			if typeof(prd[1]) == Symbol
				topid = eval(prd[1][2])
				pop!(st)
				

				for i = length(prd[1]):-1:1
					push!(st,prd[i])
				end
				@show st
			elseif typeof(prd[1]) == Symbol
				tkn = nextToken()
			end
			
			
			

			
			

		end		

		println()
		count+=1
	end


end