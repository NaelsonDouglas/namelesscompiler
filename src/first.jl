#=

S -> AdBC
A -> aBC | c | d | eps
B -> e | f

=#

include("tokens.jl")
include("data_structures.jl")

function ll1first(rule::Array{Element, 1})
    cRuleFirst = []
    has_eps = false
    for r in rule
        if r isa Token && r.categ_num != EPS
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

            append!(cRuleFirst, ll1first(r))
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

function ll1first(rule::Production)
    cRuleFirst = []
    for r in rule
        append!(cRuleFirst, ll1first(r))
    end

    unique(cRuleFist)
end

function ll1first(term::Token)
    [term]
end
