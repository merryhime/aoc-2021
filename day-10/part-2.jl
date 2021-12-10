using Underscores

matching = Dict('[' => ']', '{' => '}', '(' => ')', '<' => '>')
points = Dict('(' => 1, '[' => 2, '{' => 3, '<' => 4)
opening = Set("([{<")
closing = Set(")]}>")

function get_completion(seq)
    s = []
    for c in seq
        c ∈ opening && push!(s, c)
        c ∈ closing && c != get(matching, pop!(s), nothing) && return missing
    end
    return reverse(s)
end

score_completion(s) = @_ reduce(_1 * 5 + get(points, _2, nothing), s; init=0)

scores = @_ readlines("input") |> map(get_completion, __) |> skipmissing |> map(score_completion, __)
display(sort(scores)[length(scores)÷2 + 1])
