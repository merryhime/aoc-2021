using DataStructures, OffsetArrays, Underscores

const inf = 999999999

field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> hcat(__...)
field = OffsetArray(field, OffsetArrays.Origin(0, 0))

neighbours((x,y)) = [(x, y-1), (x-1, y), (x+1, y), (x, y+1)]
heuristic(n, goal) = sum(abs.(n .- goal))
wrap(n) = n ≤ 9 ? n : n - 9

basic(n) = get(field, n, inf)
function expanded(n)
    if any(n .< (0,0) .|| n .≥ size(field) .* 5)
        return inf
    end
    return wrap((field[(n .% size(field))...] + sum(n .÷ size(field))))
end

function search(f, start, goal, sz)
    openset = PriorityQueue{Tuple{Int,Int}, Int}()
    score = OffsetArray(fill(inf, sz...), OffsetArrays.Origin(0, 0))
    openset[start] = heuristic(start, goal)
    score[start...] = 0
    while true
        current = dequeue!(openset)
        if current == goal
            return score[current...]
        end
        for n ∈ neighbours(current)
            tmp = get(score, current, inf) + f(n)
            if tmp < get(score, n, inf)
                score[n...] = tmp
                openset[n] = tmp + heuristic(n, goal)
            end
        end
    end
end

search(basic, (0,0), size(field) .- 1, size(field)) |> display
search(expanded, (0,0), size(field) .* 5 .- 1, size(field) .* 5) |> display
