using Underscores

function main()
    field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> vcat(__'...)

    rotu(m, f) = [ m[2:end,:]            ; fill(f, 1, size(m,2)) ]
    rotd(m, f) = [ fill(f, 1, size(m,2)) ; m[1:end-1,:]          ]
    rotl(m, f) = [ m[:,2:end]              fill(f, size(m,1), 1) ]
    rotr(m, f) = [ fill(f, size(m,1), 1)   m[:,1:end-1]          ]

    mins(m) = m .< rotu(m, 9) .&& m .< rotd(m, 9) .&& m .< rotl(m, 9) .&& m .< rotr(m, 9)
    prop(m) = m .|| rotu(m, false) .|| rotd(m, false) .|| rotl(m, false) .|| rotr(m, false)

    basins = mins(field)
    depth = field .!= 9

    basin_sizes = zeros(0)
    for i in eachindex(basins)
        basins[i] || continue

        prev = falses(size(basins))
        basin = falses(size(basins))
        basin[i] = true

        while basin != prev
            prev = basin
            basin = prop(prev) .&& depth
        end

        append!(basin_sizes, count(basin))
    end

    @_ basin_sizes |> sort(__, rev=true) |> Iterators.take(__, 3) |> prod |> display
end

main()
