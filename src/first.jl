

dependencies = Dict{Symbol,Symbol}()

function calc_first(prd::Production)
	subprods = prd.subprods
	father_idx = prd.enum

  if length(prd.firsts) != 0
      return prd.firsts
  end

	for subprods_idx=1:length(subprods)

    current_prod_first = []
    for sp_prod_idx =1:length(subprods[subprods_idx])
        has_eps = false

        #verificar se a producao atual tem EPS caso tenha chamar first da proxima
        if subprods[subprods_idx][sp_prod_idx] isa Symbol
            for eps_it in getProd(subprods[subprods_idx][sp_prod_idx]).subprods
                if eps_it[1] == EPS
                    has_eps = true
                end
            end
        end

        if typeof(subprods[subprods_idx][sp_prod_idx]) == Symbol
			      #println("Começa com Produção")

			      son_idx = getProd_idx(subprods[subprods_idx][sp_prod_idx])

            if length(grammar[son_idx].firsts) == 0
			          calc_first(grammar[son_idx])
            end

            son_firsts = grammar[son_idx].firsts
			      for i in son_firsts
				        #grammar[father_idx].firsts = vcat(grammar[father_idx].firsts, i)

                # so adicionar EPS a regra caso não tenha mais nenhuma outra e.g
                # A -> BCD, first(B) = FIRST(C) - eps U First(D)
                # B -> C | eps
                # D -> d
                # so se D -> d | eps, então First(B) conteria EPS
                if i[1] == Int(EPS) && sp_prod_idx == length(subprods[subprods_idx])
                    current_prod_first = vcat(current_prod_first, i)
                elseif i[1] == Int(EPS)
                    continue
                else
                    current_prod_first = vcat(current_prod_first, i)
                end
			      end
		    else
			      #println("Começa com Token")
  	        #grammar[father_idx].firsts = vcat(grammar[father_idx].firsts, Int(subprods[subprods_idx][1]))
            current_prod_first = vcat(current_prod_first, Int(subprods[subprods_idx][sp_prod_idx]))
		    end
        if !has_eps
            break
        end
    end

      current_prod_first = unique(current_prod_first)
      push!(grammar[father_idx].firsts, current_prod_first)
	end

	#grammar[father_idx].firsts = unique(grammar[father_idx].firsts)
	return grammar[father_idx].firsts
end

#=
for p in grammar
	calc_first(p)
end
=#
