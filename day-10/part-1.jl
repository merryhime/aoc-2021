using DataStructures
using Underscores

matching = Dict([('[', ']'), ('{', '}'), ('(', ')'), ('<', '>')])
points = Dict([(')', 3), (']', 57), ('}', 1197), ('>', 25137)])
opening = Set(collect("([{<"))
closing = Set(collect(")]}>"))

function first_illegal(seq)
    s = Stack{Char}()
    for c in collect(seq)
        c ∈ opening && push!(s, c)
        c ∈ closing && c != get(matching, pop!(s), nothing) && return c
    end
end

@_ readlines("input") |> map(first_illegal, __) |> map(get(points, _, 0), __) |> sum |> display
