function main()
    input = readlines("input")
    input = replace.(input, " -> " => ",")
    input = split.(input, ",")
    input = map(x -> parse.(Int64, x), input)
    input = vcat(input'...)

    sz = max(input...) + 1
    grid = Matrix{Int64}(undef, sz, sz)
    grid[:,:] .= 0

    for i = 1:size(input, 1)
        points = input[i,:]
        points .+= 1
        if points[1] == points[3]
            grid[points[1],min(points[2],points[4]):max(points[2],points[4])] .+= 1
        elseif points[2] == points[4]
            grid[min(points[1],points[3]):max(points[1],points[3]),points[2]] .+= 1
        end
    end

    display(sum(grid .> 1))
end

main()
