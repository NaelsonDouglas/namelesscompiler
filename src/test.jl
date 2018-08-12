include("lexical.jl")

function printtoken(token)
		line  = token["line"]
		col = token["col"]
		categ_num = token["categ_num"]
		categ_nom = token["categ_nom"]
		lexem = token["lexem"]
		
		
		@printf("[%04d,%04d]",line,col)
		@printf("(%04d,%10s)",categ_num,categ_nom)
		@printf("{%s}\n",lexem)
end

#Isso vai para o programa de teste também
function loop_all()
	f = open(input)
	t = true
	line = 1
	println(readline(f))
	while (t!=false)
		t=nextToken();
		try			
			if t["line"] > line
				line+=1
				#print("(line=$line t=",t["line"],")")
				println()
				println(readline(f))				
				sleep(0.1)
			end
			printtoken(t)
		catch
		end
		#sleep(0.05)
	end
end


info("Para ler todos os tokens automaticamente use loop_all()")
info("Para ler token a token use nextToken();")
loop_all()