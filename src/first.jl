#=

S -> AdBC
A -> aBC | c | d | eps
B -> e | f

=#

include("tokens.jl")
include("data_structures.jl")

function first(rule::Array{Element, 1})
    cRuleFirst = []
    has_eps = false
    for r in rule
        if r isa Token && r != EPS
            append!(cRuleFirst, r)
            break
        else
            # verifica se a produção atual deriva vazio
            has_eps = false
            for rEPS in r.subprods
                if rEps isa Token && rEPS.categ_num == EPS
                    has_eps = true
                end
            end

            append!(cRuleFirst, first(r))
            if !has_eps
                break
            end
        end
    end

    if has_eps
        push!(cRuleFirst, EPS)
    end

    unique(cRuleFirst)
end

function first(rule::Production)
    cRuleFirst = []
    for r in rule
        append!(cRuleFirst, first(r))
    end

    unique(cRuleFist)
end

function first(term::Token)
    [term]
end
