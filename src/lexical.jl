function reg_tostring(r::Regex)
  regx = string(r)
  regx = regx[3:length(regx)-1]
  regx = strip(regx,'\$')
  return regx
end

type_str = r"(^\s*)(\"){1}(\w*)(\"){1}$"

type_int = r"^[\+|\-]?[0-9]+$"
str_type_int = reg_tostring(type_int)

type_float = string("($str_type_int)[\".\"']{1}[0-9]*\$")
type_float = Regex(type_float)

type_float = r"^([\+|\-]?[0-9]+)[\".\"']{1}[0-9]*\$"

type_float = Regex(string("(^\s*)(\-|\+){0,1}({$reg_tostring(type_int)})$"))
type_float = r"(^\s*)(\-|\+){0,1}({\type_int})$"
id =r"([a-z]|[A-Z]){1,}(\w|_|[0-9])*$"

teste = r"{type_int}|{\type_int}|{\$type_int}|{\$type_int}|{'type_int'}"

