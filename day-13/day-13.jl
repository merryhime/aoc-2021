using Underscores, PaddedViews

input = readlines("input")
points = @_ input |> filter(',' ∈ _, __) |> map(parse.(Int, split(_, ",")), __)
folds = @_ input |> filter(startswith(_, "fold along "), __) |> split.(__, "=") |> map((_[1][end], parse(Int, _[2])), __)

x_sz = @_ points |> map(_[1], __) |> max(__...)
y_sz = @_ points |> map(_[2], __) |> max(__...)

paper = falses(x_sz + 1, y_sz + 1)
for p ∈ points
    paper[p[1] + 1, p[2] + 1] = true
end

function fold(p, axis, i)
    a, b = (axis == 'x' ? (p[1:i,:], p[i+2:end,:])
                        : (p[:,1:i], p[:,i+2:end]))
    a, b = paddedviews(false, a, b)
    return a .| reverse(b; dims = axis == 'x' ? 1 : 2)
end

function part1()
    fold(paper, folds[1][1], folds[1][2]) |> count |> display
end

function part2()
    @_ folds |> reduce(fold(_1, _2[1], _2[2]), __; init=paper) |> __' |> display
end
