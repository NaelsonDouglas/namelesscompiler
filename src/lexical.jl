include("matcher.jl")
f = open(input)

#Given a lexem, 
function token(lexem,line::Int, col::Int)
	#TODO MUDAR INDEXAÇÃOO (USAR REGISTRO)
	tkn = Token(string(lexem),line,col,"",0)
	#tkn = Dict("lexem"=>string(lexem),"line"=>line, "col"=>col, "categ_nom" => " ","categ_num" => " ")
	matchedcateg =  matchlexem(lexem)

	if (matchedcateg != false)
		tkn.categ_num = matchedcateg		
		tkn.categ_nom = tks_names[matchedcateg]
	else
       	tkn.categ_num = Int(ID)	       		
       	tkn.categ_nom = tks_names[Int(ID)]
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

g = open(input,"r")
function nextToken()
	tkn = -1
	lex = -1
	col = -1
	nom = -1
	num = -1
	try
		tkn = take!(ch)
		#todo colocar o print no programa de teste e tirar do nextotken		

		#println("[",line,", ",col,"] (",categ_num,", ",categ_nom,") {",lexem,"}")

		
	catch
		#info("End of file reached")
		tkn = Token("\\eof",0,0,"EOF",Int(EOF))
	end	
	if typeof(tkn) == Token
		lex = tkn.lexem
		col = tkn.column
		nom = tkn.categ_nom
		num = tkn.categ_num
		#println("\(\"$lex\",$col,$nom,$num\)")
	else
		#info("eol")
		return false
	end
	if tkn.column == 1
		header = @sprintf("%4s  %s\n",lpad(tkn.line,4),readline(g))	
		write(tree_file,header)
		println()
		print(header)
	end
	return tkn;
end

#include("sinthatic.jl")