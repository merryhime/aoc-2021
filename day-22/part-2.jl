using Query

struct Cube
    x1::Int
    x2::Int
    y1::Int
    y2::Int
    z1::Int
    z2::Int
end

input = (readlines("input") |>
         @map(match(r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$", _).captures) |>
         @map((_[1] == "on", Cube(parse.(Int, _[2:7])...))) |>
         collect)

size(c::Cube) = max(0, c.x2-c.x1+1) * max(0, c.y2-c.y1+1) * max(0, c.z2-c.z1+1)
iszero(c::Cube) = c.x1>c.x2 || c.y1>c.y2 || c.z1>c.z2
∩(a::Cube, b::Cube) = Cube(max(a.x1, b.x1), min(a.x2, b.x2),
                           max(a.y1, b.y1), min(a.y2, b.y2),
                           max(a.z1, b.z1), min(a.z2, b.z2))
divs(c::Cube, s::Cube) = filter(x->!iszero(s) && x ≠ s,
                                Cube[Cube(i..., j..., k...)
                                     for i ∈ [(c.x1, s.x1-1) (s.x1, s.x2) (s.x2+1, c.x2)]
                                     for j ∈ [(c.y1, s.y1-1) (s.y1, s.y2) (s.y2+1, c.y2)]
                                     for k ∈ [(c.z1, s.z1-1) (s.z1, s.z2) (s.z2+1, c.z2)]])
div(c::Cube, b::Cube) = iszero(c ∩ b) ? Cube[c] : divs(c, c ∩ b)

function part2()
    @assert input[1][1]
    cubes = Cube[input[1][2]]
    for i ∈ input[2:end]
        cubes = vcat(map(c->div(c, i[2]), cubes)...)
        i[1] && push!(cubes, i[2])
    end
    display(sum(size, cubes))
end
