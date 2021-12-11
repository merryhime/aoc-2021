using Underscores

# Theoretically one could do:
#   using ImageFiltering
#   prop(m) = round.(imfilter(Matrix{Int}(m), centered(ones(3, 3)), Fill(0)))
# but the round is required due to floating point accuracy

rotu(m) = [ m[2:end,:]           ; falses(1, size(m,2)) ]
rotd(m) = [ falses(1, size(m,2)) ; m[1:end-1,:]         ]
rotl(m) = [ m[:,2:end]             falses(size(m,1), 1) ]
rotr(m) = [ falses(size(m,1), 1)   m[:,1:end-1]         ]
prop(m) = m .+ rotu(m) .+ rotd(m) .+ rotl(m) .+ rotr(m) .+ rotu(rotl(m)) .+ rotd(rotl(m)) .+ rotu(rotr(m)) .+ rotd(rotr(m))

function step!(field)
    field .+= 1
    flash = falses(size(field))
    while true
        new_flash = field .> 9 .&& .!flash
        any(new_flash) || break

        field .+= prop(new_flash)
        flash = flash .| new_flash
    end
    field[flash] .= 0
    return count(flash)
end

function part1()
    field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> vcat(__'...)
    flash_count = 0
    for i = 1:100
        flash_count += step!(field)
    end
    display(flash_count)
end

function part2()
    field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> vcat(__'...)
    time = 1
    while step!(field) != prod(size(field))
        time += 1
    end
    display(time)
end
