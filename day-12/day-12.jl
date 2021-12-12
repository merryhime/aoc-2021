using Query, Underscores

input = @_ readlines("input") |> split.(__, "-")
input = [input; (input |> @map([_[2], _[1]]) |> collect)]
cavemap = input |> @filter(_[1] != "end" && _[2] != "start") |> @groupby(_[1], _[2]) |> @map((key(_), collect(_))) |> Dict

issmall(x) = islowercase(x[1])
candup(x, path) = !issmall(x) || x ∉ path

function walk1(path = ["start"])
    if last(path) == "end"
        return 1
    end
    nexts = get(cavemap, last(path), nothing)
    return @_ nexts |> @filter(candup(_, path)) |> @map(walk1([path; _])) |> reduce(+, __; init=0)
end

function part1()
    display(walk1())
end

function walk2(path = ["start"], hasdup=false)
    if last(path) == "end"
        return 1
    end
    nexts = get(cavemap, last(path), nothing)
    return @_ nexts |> @filter(!hasdup || candup(_, path)) |> @map(walk2([path; _], hasdup || !candup(_, path))) |> reduce(+, __; init=0)
end

function part2()
    display(walk2())
end
