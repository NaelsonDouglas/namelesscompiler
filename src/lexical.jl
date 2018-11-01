input = "code.nl"

try
	using DataStructures
	using JSON
	using Match
catch
	Pkg.add("DataStructures")
	Pkg.add("JSON")
	Pkg.add("Match")
	using DataStructures
	using JSON
	using Match
end

include("tokens.jl")
include("productions.jl")
include("grammar_testing.jl")

include("auxiliar_funcs.jl")

include("matcher.jl")
include("first.jl")
include("follow.jl")




f = open(input)

mutable struct Token 
	lexem::String
	line::Int64
	column::Int64
	categ_nom::String #TODO Provavelmente é melhor tirar esse field. Não faz sentido ficar arrastando uma String para cima e para baixo em cada token. Já tem um dicionário com os nomes e que podemos pegar direto
	categ_num::Int64
end


t = open("tks.json")
tkns_nms = JSON.parse(t)
tkns_nms = SortedDict(zip(map(parse,keys(tkns_nms))  ,  values(tkns_nms)))

#Given a lexem, 
function token(lexem,line::Int, col::Int)
	#TODO MUDAR INDEXAÇÃOO (USAR REGISTRO)
	tkn = Token(string(lexem),line,col,"",0)
	#tkn = Dict("lexem"=>string(lexem),"line"=>line, "col"=>col, "categ_nom" => " ","categ_num" => " ")
	matchedcateg =  matchlexem(lexem)

	if (matchedcateg != false)
		tkn.categ_num = matchedcateg
		tkn.categ_nom = tkns_nms[matchedcateg]
	else
       	tkn.categ_num = Int(ID)	       		
       	tkn.categ_nom = tkns_nms[Int(ID)]
    end  
	return tkn
end

function producer()
	
	ch = Channel{Any}(1)
	#It says if the head of the reader is actually inside a string. In this mode blank spaces are not ignored
	stringmode = false

	@async begin
		open(input) do file
			l = 0
		 for ln in eachline(file)  #=1:length(lines)=#
		 	l+=1
			comment_mode = false
			chunks = split(ln," ")
			lineq = Queue(Token)
			lexembuff = ""
			col = 0
			chunk = -999
			for cki = 1:length(chunks) #chunk in chunks
				chunk = chunks[cki]

				if(length(chunk) > 0)
					if (chunk[1] == '#')
						break
					end
					i=1
					#for i=1:length(chunk)
					while(i<=length(chunk))
					if (chunk[i] == '"')					
						stringmode = !stringmode
					end

						if contains(==,chars_numbers,chunk[i])
							lexembuff = string(lexembuff,chunk[i])
						else

							if length(lexembuff) > 0
								enqueue!(lineq,token(lexembuff,l,col+=1))
								lexembuff = ""
							end
#TODO FAZER UMA FUNÇÃO PARA ELSE-IF
							if (contains(==,separators,chunk[i]))
								enqueue!(lineq,token(string(chunk[i]),l,col+=1))
							elseif chunk[i] == '>'
									if chunk[i+1] == '='
										enqueue!(lineq,token(">=",l,col+=1))
										i+=1
									else
										enqueue!(lineq,token(">",l,col+=1))								
									end
							
							elseif chunk[i] == '<'
									if chunk[i+1] == '='
										enqueue!(lineq,token("<=",l,col+=1))
										i+=1
									else
										enqueue!(lineq,token("<",l,col+=1))								
									end

							elseif chunk[i] == '='
									if chunk[i+1] == '='
										enqueue!(lineq,token("==",l,col+=1))
										i+=1
									else
										enqueue!(lineq,token("=",l,col+=1))								
									end
							elseif chunk[i] == ':'
									if chunk[i+1] == ':'
										enqueue!(lineq,token("::",l,col+=1))
										i+=1
									end
							end

						end
						i+=1
					end
				end
				if (length(lexembuff) > 0 && !stringmode)
								enqueue!(lineq,token(lexembuff,l,col+=1))
								lexembuff = ""
				elseif stringmode
					lexembuff = string(lexembuff," ")
				end

				if (l == countlines(input) && cki == length(chunks))
					#eoftkn = Dict("lexem"=>"\\EOF","line"=>L, "col"=>col+1, "categ_nom" => "EOF","categ_num" => " ")
					#enqueue!(lineq,token("\\eof",l,col+=1))				
				end		
			end	
			#The pop! command for Queue is not working...lol
			lineq_vector = collect(lineq)
			for i in lineq_vector
				put!(ch,i)
			end	
			put!(ch,"eol")
		end
	end

	close(ch)
end	
	return ch	
end

token(tkn::String) = token(string(tkn),0,0)

ch = producer()



#	@printf("%.3f",x)


function nextToken()
	try
		token = take!(ch)
		#todo colocar o print no programa de teste e tirar do nextotken
		

		#println("[",line,", ",col,"] (",categ_num,", ",categ_nom,") {",lexem,"}")
		return token;
	catch
		info("End of file reached")
		return Token("\eof",0,0,"EOF",EOF)
		#return false

	end	
end

calc_first()
calc_follow()
#map!(unique,firsts)

# por exemplo recebe A -> BACD, o argumento da função seria BA, essa função
# acha o FIRST de BACD.
#
# S -> ABC
# A -> xDC | a | b | eps
# B -> b | eps
# C -> c
# D -> d | i | j

function first_calc_one_rule(rule)
    c_rule_fs = []
    has_eps = false

    if rule isa Int64 && rule != EPS
        push!(c_rule_fs, rule)
        return unique(c_rule_fs)
    end

    for r1 in rule
        has_eps = false
        @show eval(r1)[1]
        for r2 in eval(r1)[1]
            @show r2[1]
            if r2[1] != EPS
                append!(c_rule_fs, first(r2[1]))
            else
                has_eps = true
            end
        end
        if !has_eps
            break
        end
    end

    if has_eps
        push!(c_rule_fs, EPS)
    end

    return unique(c_rule_fs)
end

rules_count = 0
terminals_count_aux = []
for it_g in grammar
    for term in it_g[1][1]
        if term isa Int64
            push!(terminals_count_aux, term)
        end
    end
end

first_calc_one_rule(eval(:TYPE)[1])

#=
predict_table = Array{Any, 2}(length(grammar), length(unique(terminals_count_aux)))

for r in grammar
    has_eps = false

    if has_eps
        
    end

end
=#


#include("sinthatic.jl")
#sinthatic()
#=
m = collect(instances(Prods))
for i=1:length(firsts)
	println(m[i])
	println(string(i)*"--",firsts[i],)
	println()
end
=#


