using Query, Underscores

input = @_ readlines("input") |> split.(__, "-")
input = [input; (input |> @map(reverse(_)) |> collect)]
cavemap = input |> @filter(_[1] != "end" && _[2] != "start") |> @groupby(_[1], _[2]) |> @map((key(_), collect(_))) |> Dict

issmall(x) = islowercase(x[1])
isdup(x, path) = issmall(x) && x ∈ path

function walk(path = ["start"], candup=false)
    if last(path) == "end"
        return 1
    end
    nexts = get(cavemap, last(path), nothing)
    return @_ nexts |> @filter(candup || !isdup(_, path)) |> @map(walk([path; _], candup && !isdup(_, path))) |> reduce(+, __; init=0)
end

function part1()
    display(walk(["start"], false))
end

function part2()
    display(walk(["start"], true))
end
