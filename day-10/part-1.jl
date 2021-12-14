using Underscores

matching = Dict('[' => ']', '{' => '}', '(' => ')', '<' => '>')
points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
opening = Set("([{<")
closing = Set(")]}>")

function first_illegal(seq)
    s = []
    for c in seq
        c ∈ opening && push!(s, c)
        c ∈ closing && c != matching[pop!(s)] && return points[c]
    end
    return 0
end

@_ readlines("input") |> map(first_illegal, __) |> sum |> display
