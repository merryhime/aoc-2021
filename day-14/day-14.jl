using DataStructures, Query, Underscores

# format: 12 -> 7
gen_rule(r) = ((r[1], r[2]), [(r[1], r[7]), (r[7], r[2])])

reducecount(pairs) = @_ pairs |> map(counter(Dict([_])), __) |> reduce(merge, __)

template, rules = open("input", "r") do io
    readline(io),
    eachline(io) |> @filter(occursin(" -> ", _)) |> @map(gen_rule(_)) |> Dict
end
rules[(template[end], '$')] = [(template[end], '$')]

function run(n)
    pairs = zip(template[1:end], template[2:end] * '$') |> counter
    for i=1:n
        pairs = [(y, x.second) for x ∈ pairs for y ∈ rules[x.first]] |> reducecount
    end
    c = [(x.first[1], x.second) for x ∈ pairs] |> reducecount |> values
    return max(c...) - min(c...)
end

display(run(10))
display(run(40))
