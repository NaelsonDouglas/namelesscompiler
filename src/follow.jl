amnt_productions = length(collect(map(Int,instances(Prods))))
follows = Vector{Vector}(amnt_productions)
fill!(follows,Vector())


function calc_follow(g=grammar)

	for prod_i in g
		prods_body   = get_productions(prod_i)
		for sent in prods_body

			for cell=1:(length(sent)-1)
				if typeof(sent[cell]) == Symbol
					flwsindex = eval(sent[cell])
					flwsindex = eval(sent[cell])[2]				
						
						next = sent[cell+1]

						if (typeof(next) == Int)
							follows[flwsindex] = vcat(follows[flwsindex],next)
						elseif typeof(next) == Symbol
							expanded = eval(next)
							next_id = expanded[2]
							follows[flwsindex] = vcat(follows[eval(sent[cell])[2]],firsts[expanded[2]])
						end					

				else
					#Do nothing. 
					#The follow is defined only for non-terminals
					#Symbols are productions, Integers are tokens
				end
			end

		end

	end	

	#Removes duplicated values on the follows list
	for i=1:length(follows)
		follows[i] = unique(follows[i])
	end

end


"It's an auxiliar and ugly function. Nothing special to see here."
function reverse_follow()
	names = collect(instances(Prods))
	for i=1:length(follows)
		
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
		println(follows[i])
	end
end