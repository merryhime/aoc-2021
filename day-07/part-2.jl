using LinearAlgebra
using Underscores

triangular_number(x) = sum(1:x)

function main()
    input = @_ read("input", String) |> strip |> split.(__, ",") |> parse.(Int64, __)
    sz = max(input...) + 1

    state = collect(sum(input' .== 0:sz-1, dims=2))
    fuel = Vector{Int64}(undef, sz)

    for pos = 1:sz
        cost = triangular_number.(abs.(collect(1:sz) .- pos))
        fuel[pos] = cost ⋅ state
    end

    display(min(fuel...))
end

main()
