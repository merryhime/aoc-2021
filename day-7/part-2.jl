using LinearAlgebra

function triangular_number(x)
    return sum(1:x)
end

function main()
    input = read("input", String)
    input = split.(strip(input), ",")
    input = parse.(Int64, input)
    input .+= 1

    sz = max(input...)
    fuel = Vector{Int64}(undef, sz)
    state = sum(input' .== 1:sz, dims=2)[:]

    for pos = 1:sz
        cost = triangular_number.(abs.(collect(1:sz).-pos))
        fuel[pos] = cost ⋅ state
    end

    display(min(fuel...))
end

main()
