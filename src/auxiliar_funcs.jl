Base.length(s::Symbol) = 1

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

function get_productionid(prod::Union{Symbol,Array{Any,1}})
	if typeof(prod) == Symbol
		p = eval(prod)
		return p[2]
	else
		return prod[2]
	end
end

function get_productions(id::Union{Int,Symbol,Array{Any,1}})	
	tp = typeof(id)
	if tp == Int
		return productions[id]
	elseif tp == Symbol
		return eval(id)[1]
	elseif tp == Array{Any,1}
		return id[1]
	end	
end