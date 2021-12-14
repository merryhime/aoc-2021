using DataStructures, Query

# format: 12 -> 7
gen_rule(r) = ((r[1], r[2]), [(r[1], r[7]), (r[7], r[2])])

template, rules = open("input", "r") do io
    readline(io), (eachline(io) |> @filter(occursin(" -> ", _)) |> @map(gen_rule(_)) |> Dict)
end
rules[(template[end], '$')] = [(template[end], '$')]

function run(n)
    pairs = zip(template[1:end], template[2:end] * '$') |> collect |> counter
    for i=1:n
        next = Dict{Tuple{Char, Char}, Int}()
        for p ∈ pairs
            for n ∈ rules[p.first]
                next[n] = get(next, n, 0) + p.second
            end
        end
        pairs = next
    end
    c = Dict{Char, Int}()
    for p ∈ pairs
        c[first(p.first)] = get(c, first(p.first), 0) + p.second
    end
    c = c |> @map(_.second)
    return max(c...) - min(c...)
end

display(run(10))
display(run(40))
