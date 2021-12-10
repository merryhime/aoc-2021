input = readlines("input")

m = map(x -> collect(x) .== '1', input)
m = vcat(m'...)

mid = size(m, 1) / 2
counts = sum(m, dims=1)[:]

function ba_to_int(b)
    return sum((2 .^ collect(0:length(b)-1))[reverse(b)])
end

gamma = ba_to_int(counts .> mid)
epsilon = ba_to_int(counts .< mid)

print(gamma * epsilon)
