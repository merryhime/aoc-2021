input = readlines("input")
input = parse.(Float64, input)

output = sum(input[1:end-1] .< input[2:end])

print(output)
