input = readlines("input")
input = split.(input, " ")

dir = getindex.(input, 1)
val = getindex.(input, 2)
val = parse.(Int64, val)

aimoff = deepcopy(val)
aimoff[dir .== "down"] *= +1
aimoff[dir .== "up"] *= -1
aimoff[dir .== "forward"] .= 0
aim = accumulate(+, aimoff)

forward = dir .== "forward"

horiz = sum(val[forward])
depth = sum(val[forward] .* aim[forward])

print(horiz * depth)
