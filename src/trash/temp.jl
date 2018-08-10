function matchlexem(item::String)

	if (item == "EOF")
		return Int(EOF)
	end

	#Checks if the lexem has invalid characters	
	invalidpart = 
	filter(lexem) do x
			!contains(==,vcat(digits_only,chars),x)
	end	

	if (legnth(invalidpart > 0))
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
		
	if item[1] == '\'' && item[length(item)] == '\'' #if it starts and ends with \)
		return Int(CT_CHAR)
	end 

	#From this point we are sure the token is not a number neither is a string
	return	@match item begin
				"~" => Int(OPR_UN_NEG)
				"[" => Int(O_BRCKT)
				"]" => Int(C_BRCKT)
				"(" => Int(O_PRTSIS)
				")" => Int(C_PRTSIS)
				"," => Int(COMMA)
				";" => Int(SMCL)
				"(" => Int(O_PRTSIS)
				"{" => Int(O_C_BRCKT)
				"}" => Int(C_C_BRCKT)
				"=" => Int(OPR_ATR)
				">" => Int(OPRLR_LGT)
				"<" => Int(OPRLR_LGT)
				">=" => Int(OPRLR_LGT_EQ)
				"<=" => Int(OPRLR_LGT_EQ)
				"int" => Int(IDT_INT)
				"float" => Int(IDT_FLOAT)
				"char" => Int(IDT_CHAR)
				"string" => Int(IDT_STRING)
				"print" => Int(FN_PRINT)
				"main" => Int(FN_MAIN)
				"::" => Int(VEC_IN)  #From this point we are sure the token is not an operator or a reserved symbol
				"EOF" => Int(EOF)
				 _ => false
			end


end
























