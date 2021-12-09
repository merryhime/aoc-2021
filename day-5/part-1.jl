using Underscores

function main()
    input = @_ readlines("input") |> replace.(__, " -> " => ",") |> split.(__, ",") |> map(parse.(Int64, _), __)

    sz = max(max.(input...)...) + 1
    grid = zeros(Int64, sz, sz)

    for points in input
        points .+= 1 # 1-indexing
        if points[1] == points[3]
            grid[points[1],min(points[2],points[4]):max(points[2],points[4])] .+= 1
        elseif points[2] == points[4]
            grid[min(points[1],points[3]):max(points[1],points[3]),points[2]] .+= 1
        end
    end

    display(sum(grid .> 1))
end

main()
