

dependencies = Dict{Symbol,Symbol}()

function calc_first(prd::Production)
	subprods = prd.subprods
	father_idx = prd.enum

	
	for subprods_idx=1:length(subprods)

		if typeof(subprods[subprods_idx][1]) == Symbol
			#println("Começa com Produção")	
			@show subprods[subprods_idx][1]
			son_idx = getProd_idx(subprods[subprods_idx][1])

			son_firsts =calc_first(grammar[son_idx])
			for i in son_firsts
				grammar[father_idx].firsts = vcat(grammar[father_idx].firsts,i)
			end
		else			
			#println("Começa com Token")
			
			grammar[father_idx].firsts = vcat(grammar[father_idx].firsts,Int(subprods[subprods_idx][1]))

		end

	end
	grammar[father_idx].firsts = unique(grammar[father_idx].firsts)
	return grammar[father_idx].firsts


end
#=
for p in grammar
	calc_first(p)
end
=#
