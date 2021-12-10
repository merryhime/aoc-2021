using RollingFunctions

input = readlines("input")
input = parse.(Float64, input)

s = rolling(sum, input, 3)

output = sum(s[1:end-1] .< s[2:end])

print(output)
