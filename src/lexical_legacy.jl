using DataStructures
using JSON


f = open("code.nl")

t = open("tokens.json")
tkns_ids = JSON.parse(t)

chars = vcat(collect('A':'Z'),collect('a':'z'),'"')
pure_numbers = ['0', '1','2','3','4','5','6','7','8','9'] 
numbers =  vcat(pure_numbers,['+','-','.'])

charssnumbers = vcat(chars,numbers)

terminals = ['[', ']','{','}','(',')',';',',','-','*',"/"]

function checkisint(lexem::String)
	try
		parse(Int,lexem)

		if (contains(==,lexem,'.'))
			return false
		end
			return true
	catch
		return false
	end
end;

function checkisfloat(lexem::String)
	try
		parse(Float64,lexem)
			return true
	catch
		return false
	end
end;

checkisnumber(lexem::String) = checkisfloat(lexem)

function token(lexem,line::Int, col::Int)
	

	tkn = Dict("lexem"=>string(lexem),"line"=>line, "col"=>col, "categ_nom" => " ","categ_num" => " ")

	if (contains(==,pure_numbers,lexem[1]) && !checkisnumber(lexem))
		tkn["categ_nom"] = "LEX_ERR"
	elseif checkisnumber(lexem)		
		if (checkisint(lexem))
			tkn["categ_nom"] = "TYPE_INT"
			#tkn["lexem"] = string(intlexem) No casts allowed
		else
			tkn["categ_nom"] = "TYPE_FLOAT"
		end
	elseif lexem[1] == '"' && lexem[length(lexem)] == '"' #if it starts and ends with \"
		tkn["categ_nom"] = "CT_STRING"		
		tkn["categ_num"] = tkns_ids["CT_STRING"]
	elseif lexem[1] == '\'' && lexem[length(lexem)] == '\'' #if it starts and ends with \"
		tkn["categ_nom"] = "TYPE_CHAR"
	else #From this point we are sure the token is not a number and doesnt start with a number
		if lexem == "["
			tkn["categ_nom"] = "O_BRCKT"			
		elseif lexem == "]"
			tkn["categ_nom"] = "C_BRCKT"		
		elseif lexem == "("
			tkn["categ_nom"] = "O_PRTSIS"		
		elseif lexem == ")"
			tkn["categ_nom"] = "C_PRTSIS"		
		elseif lexem == ","
			tkn["categ_nom"] = "COMMA"		
		elseif lexem == ";"
			tkn["categ_nom"] = "SMCL"					
		elseif lexem == "("
			tkn["categ_nom"] = "O_PRTSIS"		
		elseif lexem == "{"
			tkn["categ_nom"] = "O_C_BRCKT"		
		elseif lexem == "}"
			tkn["categ_nom"] = "C_C_BRCKT"		
		elseif lexem == "="
			tkn["categ_nom"] = "OPR_ATR"		
		elseif lexem == ">"
			tkn["categ_nom"] = "OPRLR_LGT"		
		elseif lexem == "<"
			tkn["categ_nom"] = "OPRLR_LGT"		
		elseif lexem == ">="
			tkn["categ_nom"] = "OPRLR_LGT_EQ"		
		elseif lexem == "<="
			tkn["categ_nom"] = "OPRLR_LGT_EQ"		
		elseif lexem == "int"
			tkn["categ_nom"] = "IDT_INT"		
		elseif lexem == "float"
			tkn["categ_nom"] = "IDT_FLOAT"		
		elseif lexem == "char"
			tkn["categ_nom"] = "IDT_CHAR"		
		elseif lexem == "string"
			tkn["categ_nom"] = "IDT_STRING"		
		elseif lexem == "print"
			tkn["categ_nom"] = "FN_PRINT"		
		elseif lexem == "main"
			tkn["categ_nom"] = "FN_MAIN"				
		elseif lexem == "::"
			tkn["categ_nom"] = "VEC_IN"		
			 #From this point we are sure the token is not an operator or a reserved symbol
		elseif "lexem" == "EOF"
			tkn["categ_nom"] = "EOF"		
		else  
			#Removes all the valid characters from the lexem and tries to leave it only with unnaceptable chars
			invalidpart = 
			filter(lexem) do x
       			!contains(==,vcat(pure_numbers,chars),x)
       		end

       		if (lexem != "EOF")
	       		#If it has invalid characters, then the token is an error
	       		if length(invalidpart) > 0
	       			tkn["categ_nom"] = "LEX_ERR"
	       		else
	       		#If it doesnt have invalid characters, than it's an variable
	       			tkn["categ_nom"] = "ID"
	       		end
	       	else
	       			tkn["categ_nom"] = "EOF"
	       	end

		end



		try
			tkn["categ_num"] = tkns_ids[tkn["categ_nom"]] #tkn is a dict maped from the tokens.json file
		catch
			tkn["categ_num"] = -9999999 #Uncategorized token ---> The goal is to make this line never be executed. 
		end
	end
		return tkn

end

function producer()
	

	ch = Channel{Any}(1)
	#It says if the head of the reader is actually inside a string. In this mode blank spaces are not ignored
	stringmode = false


	lines = readlines(f)

	@async begin
	 for l=1:length(lines)
		comment_mode = false
		chunks = split(lines[l]," ")
		lineq = Queue(Dict)
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

					if contains(==,charssnumbers,chunk[i])
						lexembuff = string(lexembuff,chunk[i])
					else

						if length(lexembuff) > 0
							enqueue!(lineq,token(lexembuff,l,col+=1))
							lexembuff = ""
						end

						if (contains(==,terminals,chunk[i]))
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

			if (l == length(lines) && cki == length(chunks))
				#eoftkn = Dict("lexem"=>"\\EOF","line"=>L, "col"=>col+1, "categ_nom" => "EOF","categ_num" => " ")
				enqueue!(lineq,token("EOF",l,col+=1))				
			end



			
		end	


		#The pop! command for Queue is not working...lol
		lineq_vector = collect(lineq)
		for i in lineq_vector
			put!(ch,i)
		end	
	end

	close(ch)
end	
	return ch
	
end

ch = producer()

function nextToken()
	try
		token = take!(ch)
		println("[",token["line"],", ",token["col"],"] (",token["categ_num"],", ",token["categ_nom"],") {",token["lexem"],"}")
		return token;
	catch
		#Info("End of file reached")
		return false

	end
	
end
