
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

	if (item == "EOF")
		return Int(EOF)
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
		
	if item[1] == '\'' && item[length(item)] == '\'' #if it starts and ends with \)
		return Int(CT_CHAR)
	end 

	#From this point we are sure the token is not a number neither is a string
	return	@match item begin
				"for"=>Int(BLK_FOR)
				"while"=>Int(BLK_WHILE)
				"return"=>Int(RETURN)
				"~" => Int(OPR_UN_NEG)
				"-" => Int(OPR_SUB)
				"*" => Int(OPR_DM)
				"/" => Int(OPR_DM)
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
				"==" => Int(OPRLR_EQ)
				">" => Int(OPRLR_GT)
				"<" => Int(OPRLR_LG)
				">=" => Int(OPRLR_LGT_EQ)
				"<=" => Int(OPRLR_LGT_EQ)
				"::" => Int(VEC_IN)
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
























