mutable struct Token 
	lexem::String
	line::Int64
	column::Int64
	categ_nom::String #TODO Provavelmente é melhor tirar esse field. Não faz sentido ficar arrastando uma String para cima e para baixo em cada token. Já tem um dicionário com os nomes e que podemos pegar direto
	categ_num::Int64
end
#=
function Token(lexem_::String,	line_::Int64,column_::Int64,categ_nom_::String,categ_num_::Int64)	
	Token(lexem_,line_,column_,categ_nom_,categ_nom_,categ_num_)
end
=#




#This is not working
#Todo, research the reason for that
function Base.show(tkn::Token) 
	lex = tkn.lexem
	col = tkn.column
	nom = tkn.categ_nom
	num = tkn.categ_num
	println("\(\"$lex\",$col,$nom,$num\)")
end


mutable struct Production
	lexem::String
	subprods
	enum::Int		
end

 
function Production(subprods_,enum_)
	prd = Production("",subprods_,enum_)
end

function Production(subprods_)
	Production(subprods_,-1)
end

Element = Union{Token,Production}




#Lembrar que Element é a união de Token e Production. A definição destes tipos estão em data_structures.jl

	


function getLexem(enum::Int)
	grammar[enum].lexem
end


function printToken(tkn::Token)
	@sprintf("              [%04d, %04d] (%04d,%10s){%s}",tkn.line,   tkn.column,   tkn.categ_num,   tkn.categ_nom,   tkn.lexem)
end

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