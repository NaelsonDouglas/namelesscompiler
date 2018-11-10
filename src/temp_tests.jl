function prodToString(prod::Production)
	output = ""

	output = prod.lexem*" -> "


	for i=1:length(prod.subprods)

		for elem in prod.subprods[i]
			if typeof(elem) == Symbol
				output = output*string(elem)
			else
        if Int(elem) == Int(EPSILON)
  		    output = output*lowercase(string(" "))
        else
          output = output*lowercase(string(elem))
        end
			end
			output = output*" "
		end

		if i != length(prod.subprods)
			output = output*" | "
		end
	end
	return output*". \n"
end

function convertGrammar(g=grammar)
	output_prof = ""
	output_code = ""
	prof_file = open("grammar_prof.txt","w+")
	code_file = open("grammar_code.txt","w+")
	for p in grammar
		line = prodToString(p)
		output_code = output_code*line
		
		buff_prof = replace(line,"|   .","| epsilon")
		buff_prof = replace(buff_prof,". ","")		 
		buff_prof = replace(buff_prof,"->","=")
		buff_prof = replace(buff_prof,"  "," ")
		output_prof = output_prof*buff_prof*"\n"

	end
	f = open("../especificações/gramática.txt","w+")
	write(f,output_prof)
	flush(f)
	close(f)

	f = open("grammar","w+")
	write(f,output_code)
	flush(f)
	close(f)	
end



