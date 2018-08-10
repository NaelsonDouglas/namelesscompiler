using DataStructures
using JSON
include("tokens.jl")

chars = vcat(collect('A':'Z'),collect('a':'z'),'"')
digits_only = ['0', '1','2','3','4','5','6','7','8','9'] 
numbers =  vcat(digits_only,['+','-','.'])
charssnumbers = vcat(chars,numbers)
terminals = ['[', ']','{','}','(',')',';',',','-','*',"/"]

f = open("code.nl")

t = open("tks.json")
tkns_nms = JSON.parse(t)
tkns_nms = SortedDict(zip(map(parse,keys(tkns_nms))  ,  values(tkns_nms)))



chars = vcat(collect('A':'Z'),collect('a':'z'),'"')
digits_only = ['0', '1','2','3','4','5','6','7','8','9'] 
numbers =  vcat(digits_only,['+','-','.'])
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
	matchedcateg =  matchlexem(lexem)

	if (matchedcateg != false)
		tkn["categ_num"] = matchedcateg		
		tkn["categ_nom"] = tkns_nms[matchedcateg]
	else
       	tkn["categ_num"] = Int(ID)	       		
       	tkn["categ_nom"] = tkns_nms[Int(ID)]
    end
    #=
	try
		tkn["categ_num"] = tkns_ids[tkn["categ_nom"]] #tkn is a dict maped from the tokens.json file
	catch
		tkn["categ_num"] = -9999999 #Uncategorized token ---> The goal is to make this line never be executed. 
	end
	=#

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