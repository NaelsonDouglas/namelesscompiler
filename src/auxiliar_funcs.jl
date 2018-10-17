"Turns a vector into single column
v = [1,2,[3,2,[3,4,5,6,1,1,1,11,1]]]
plainvector(v)'
1  2  3  4  5  6  11
The boolean unq specifies if the output will be filtered to return a vector of unique values
"
function plainvector(_v,unq=true)
	
	v = copy(_v)
	for i=1:length(v)
		if typeof(v[i])!=Int
			bucket = collect(v[i])
			deleteat!(v,i)

			v=vcat(v,plainvector(bucket,unq))
		end
	end

	for i=1:length(v)
		if typeof(v[i])  != Int
			v[i] = v[i][1]
		end
	end

	unq? unique(v) : v
end





