input_code = "code.nl"
include("tokens.jl")

chars = vcat(collect('A':'Z'),collect('a':'z'),'"')
numbers = ['0', '1','2','3','4','5','6','7','8','9'] 
numbers_operators =  vcat(numbers,['+','-','.'])
charsnumbers = vcat(chars,numbers)
spacers = ['[', ']','{','}','(',')',';',',','-','+','*','/']




f = open(input_code)
while !eof(f)
	c = read(f,Char)
	print(c)
end


function producer(input_code::String)
	ch = Channel{Any}(1)
	f = open(input_code)

	@async begin
		
		while !eof(input_code)
			c = read(f,Char)
			
			put!(ch,i)
		end
		
		close(ch)
	end	


	return ch	
end

ch = producer()
take!(ch)