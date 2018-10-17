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
include("matcher.jl")
include("first.jl")
include("productions.jl")


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
					enqueue!(lineq,token("\\eof",l,col+=1))				
				end		
			end	
			#The pop! command for Queue is not working...lol
			lineq_vector = collect(lineq)
			for i in lineq_vector
				put!(ch,i)
			end	
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
		return false

	end	
end






firsts=map(calc_first,productions)

dict_firsts = SortedDict(zip(collect(instances(Prods)),firsts))