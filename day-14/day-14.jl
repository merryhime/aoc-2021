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
        pairs = pairs |> @map(x->map(y->(y, x.second), get(rules, x.first, []))) |> Iterators.flatten |> @groupby(first(_)) |> @map((key(_), collect(_) |> @map(x->x[2]) |> sum)) |> Dict
    end
    c = pairs |> @groupby(first(first(_))) |> @map(collect(_) |> @map(x->x[2]) |> sum)
    return max(c...) - min(c...)
end

display(run(10))
display(run(40))
