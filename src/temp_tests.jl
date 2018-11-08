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
	output = ""
	for p in grammar
		output = output*prodToString(p)
	end
	f = open("grammar_prof.txt","w+")
	write(f,output)
	flush(f)
	close(f)
	return output
end



