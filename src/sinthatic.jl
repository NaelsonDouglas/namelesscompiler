function getTblMatch(;production_::Symbol=:S,token_::Union{Symbol,Int}=:return)
	tkn = -1
	if typeof(token_) == Int
		tkn = Symbol(uppercase(tks_names[token_]))
		
	else
		tkn = token_
	end

	tkn = Symbol(lowercase(string(tkn)))			
	return table[tkn][getProd_idx(production_)]
end
function prodToString(prd::Production)
	output = ""

	output = prd.lexem*"-> "


	for i=1:length(prd.subprods)

		for elem in prd.subprods[i]
			if typeof(elem) == Symbol
				output = output*string(elem)
			else
				output = output*lowercase(string("'",elem,"'"))
			end
			output = output*" "
		end

		if i != length(prd.subprods)
			output = output*" | "
		end
	end
	return output*"\n"
end

function stringToProd(production::String)
	try
		prd = uppercase(production)
		splited = split(prd,"=")
		name = splited[1]
		enum = getProd_idx(Symbol(name))
		prd = splited[2]
		prd = split(prd," ")
		prd = map(Symbol,prd)
		
		output = Production(prd)
		output.enum = enum
		output.lexem = name
		return output
	catch
		return []
	end
end

function reverseRule(production_::Union{String,Production})
	production = -1
	if typeof(production_) == String
		production = stringToProd(production_)
	end
	output = Symbol[]
	sprods = production.subprods
	for p=length(sprods):-1:1
		output = vcat(output,sprods[p])
	end
	return output
end


function isProduction(p::Symbol)
	try
		getProd(p)
		return true
	catch
		return false
	end
end



function print_analyzer()
	println("Pilha: ",top(stack))
	println("Fita: ",head.lexem)			
	println("Regra: ",rule)
	println()
end

function makestepleft(lexem::String)
	len = length(lexem)

	df = 13 - len

	x = lexem

	for i=1:df
		x=x*" "
	end
	x=x*"  ->   "
	return x
end

stack = Stack(Union{Symbol,Int})

push!(stack,:S)

head = false
head = nextToken();	
move_head = false
rule = ""
steps = String["entrada          |             Pilha"]


tabs=0
while(head == false || head.categ_num != Int(EOF)) #head == false ---> end of line
	
	
	
	if head != false #Se não tiver um eol na fita					

		newline = string(makestepleft(head.lexem),string(collect(stack)))
		steps = vcat(steps,newline)
		if isProduction(top(stack)) #Se tiver uma produção no topo da pilha		
			rule = getTblMatch(production_=top(stack),token_=head.categ_num)
			
			tree_buff=""
			for i=1:tabs
				print("\t")
				#@printf("%s","\t")
				tree_buff=vcat(tree_buff,@sprintf("%s","\t")) #yeah, I know calling @printf and @sprintf twice is lame, But its bugging.
			end
			println("          ",rule)
			tree_buff=vcat(tree_buff,@sprintf("%s%s","          ",rule*"\n"))
			write(tree_file,tree_buff)

			tabs=tabs+1			
			r_rule = reverseRule(rule)			
			pop!(stack)


			for i in r_rule
				push!(stack,i)
			end
			#sleep(1)
			#@show "loop"
		else		
			
			if Int(eval(top(stack))) == Int(EPSILON)
				pop!(stack)
			else
				pop!(stack)
				printToken(head)
				println()
				head = nextToken();
				tabs=0
				if head == false #Se for um eol, pula a fita de novo					
					head = nextToken();	
				end
			end			
		end

		if typeof(head)!=Bool
			if head.categ_num == Int(EOF)
				if top(stack) == :S

					newline = string(makestepleft(head.lexem),string(collect(stack)))
					pop!(stack)				
					steps = vcat(steps,newline)

					newline = string(makestepleft(head.lexem),string(collect(stack)))
					steps = vcat(steps,newline)
				end
			end
		else
			head = nextToken();
		end
	end
end