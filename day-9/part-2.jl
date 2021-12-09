using Underscores

function main()
    original = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> vcat(__'...)

    rotu(m, f) = [ m[2:end,:]            ; fill(f, 1, size(m,2)) ]
    rotd(m, f) = [ fill(f, 1, size(m,2)) ; m[1:end-1,:]          ]
    rotl(m, f) = [ m[:,2:end]              fill(f, size(m,1), 1) ]
    rotr(m, f) = [ fill(f, size(m,1), 1)   m[:,1:end-1]          ]

    mins(m) = m .< rotu(m, 9) .&& m .< rotd(m, 9) .&& m .< rotl(m, 9) .&& m .< rotr(m, 9)
    prop(m) = m .|| rotu(m, false) .|| rotd(m, false) .|| rotl(m, false) .|| rotr(m, false)

    field = deepcopy(original)
    basins = mins(field)
    depth = field .!= 9

    basin_sizes = zeros(0)

    for i in eachindex(basins)
        if !basins[i]
            continue
        end

        basin = falses(size(basins))
        basin[i] = true

        while true
            p = prop(basin) .&& depth

            if sum(p .&& .!basin) == 0
                break
            end

            basin[p] .= true
        end

        sz = sum(basin)

        append!(basin_sizes, sz)
    end

    @_ basin_sizes |> sort(__, rev=true) |> Iterators.take(__, 3) |> prod(__) |> display(__)
end

main()
