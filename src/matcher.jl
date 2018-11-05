chars_only = vcat(collect('A':'Z'),collect('a':'z'),'"')
digits_only = ['0', '1','2','3','4','5','6','7','8','9'] 
numbers =  vcat(digits_only,['+','-','.'])

chars_numbers = vcat(chars_only,numbers)
separators = ['[', ']','{','}','(',')',';',',','-','*','/',' ','<','>','=',' ']
valid_chars = vcat(chars_numbers,separators,':')

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


function matchlexem(item::String)

	

	if (item == "!=")
		return Int(OPRLR_REL)
	end
	if (item == ">")
		return Int(OPRLR_REL)
	end

	#Checks if the lexem has invalid characters	
	invalidpart = 
	filter(item) do x
			!contains(==,vcat(valid_chars),x)
	end	

	if (length(invalidpart) > 0)		
		return Int(LEX_ERR)
	end


	if (contains(==,digits_only,item[1]) && !checkisnumber(item)) #if the lexem starts with a number, but the lexem itself is not a number
		return Int(LEX_ERR)
	end

	if checkisnumber(item)
		if (checkisint(item))
			return Int(CT_INT)
		else
			return Int(CT_FLOAT)
		end
	end

	if item[1] == '"' && item[length(item)] == '"' #if it starts and ends with "
		return Int(CT_STRING)
	end


	#TODO ISSO AQUI TÁ PERMITINDO CHAR DE TAMANHO >1	
	if item[1] == '\'' && item[length(item)] == '\'' #if it starts and ends with \)
		return Int(CT_CHAR)
	end 

	#From this point we are sure the token is not a number neither is a string
	
	return	@match item begin
				"for"=>Int(BLK_FOR)
				"while"=>Int(BLK_WHILE)
				"return"=>Int(RETURN)
				"~" => Int(OPR_UN_NEG)
				"-" => Int(OPR_PM)
				"+" => Int(OPR_PM)
				"++" => Int(OPR_CONCAT)
				"*" => Int(OPR_DM)
				"/" => Int(OPR_DM)
				"[" => Int(O_SQRBRCKT)
				"]" => Int(C_SQRBRCKT)				
				"(" => Int(O_BRCKT)
				")" => Int(C_BRCKT)				
				"," => Int(COMMA)
				";" => Int(SMCL)				
				"{" => Int(O_C_BRCKT)
				"}" => Int(C_C_BRCKT)				
				"==" => Int(OPRLR_REL)
				"=" => Int(OPR_ATR)
				">" => Int(OPRLR_REL)
				"<" => Int(OPRLR_REL)
				">=" => Int(OPRLR_REL)
				"<=" => Int(OPRLR_REL)				
				"!=" => Int(OPRLR_REL)
				"if" => Int(BLK_IF)
				"int" => Int(IDT_INT)
				"float" => Int(IDT_FLOAT)
				"void" => Int(IDT_VOID)
				"char" => Int(IDT_CHAR)
				"string" => Int(IDT_STRING)
				"print" => Int(FN_PRINT)
				"main" => Int(FN_MAIN)
				"AND" => Int(OPRLR_AND)
				"OR" => Int(OPRLR_OR)
				"NOT" => Int(OPRL_NOT)
				"true" => Int(CT_TRUE)
				"false" => Int(CT_FALSE)
				"#" => Int(CMNT_LN)
				"::" => Int(VEC_IN)				
				"EOF" => Int(EOF)
				 _ => false
			end
end
























