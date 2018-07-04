"Parses a regex into a string"
function rxstr(r::Regex)
  regx = string(r)
  regx = regx[3:length(regx)-1]
  regx = strip(regx,'\$')
  return regx
end

oprp = Regex("[+|-]")
oprm = Regex("[/|*]")
oprln = Regex("not")
type_str = Regex("(\").*(\")\$")
type_int = Regex(rxstr(oprp)*"?[0-9]+\$")
type_float = Regex("("*rxstr(type_int)*")[\".\"']{1}[0-9]*\$")
id = Regex("^[A-Z|a-z]+(\w)*")

	







