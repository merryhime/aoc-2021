input = readlines("input")
input = split.(input, " ")

dir = getindex.(input, 1)
val = getindex.(input, 2)
val = parse.(Int64, val)

horiz = sum(val[dir .== "forward"])
depth = sum(val[dir .== "down"]) - sum(val[dir .== "up"])

print(horiz * depth)
