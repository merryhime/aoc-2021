using OffsetArrays, Underscores

const inf = 999999999

field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> hcat(__...)
field = OffsetArray(field, OffsetArrays.Origin(0, 0))

neighbours((x,y)) = [(x, y-1), (x-1, y), (x+1, y), (x, y+1)]
heuristic(n, goal) = sum(abs.(n .- goal))
wrap(n) = n <= 9 ? n : n - 9

basic(n) = get(field, n, inf)
function expanded(n)
    if any(n .< (0,0) .|| n .>= size(field) .* 5)
        return inf
    end
    return wrap((field[(n .% size(field))...] + sum(n .÷ size(field))))
end

function search(start, goal, f)
    openset = Set([start])
    gscore = Dict(start => 0)
    fscore = Dict(start => heuristic(start, goal))
    while !isempty(openset)
        current = argmin(x->fscore[x], openset)
        if current == goal
            return fscore[current]
        end
        delete!(openset, current)
        for n ∈ neighbours(current)
            tmp = get(gscore, current, inf) + f(n)
            if tmp < get(gscore, n, inf)
                gscore[n] = tmp
                fscore[n] = tmp + heuristic(n, goal)
                if n ∉ openset
                    push!(openset, n)
                end
            end
        end
    end
end

search((0,0), size(field) .- 1, basic) |> display
search((0,0), size(field) .* 5 .- 1, expanded) |> display
