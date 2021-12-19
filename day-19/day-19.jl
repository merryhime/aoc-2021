using DataStructures, Query

const Coord = Tuple{Int, Int, Int}
negate(c::Coord) = (0,0,0) .- c

const Scanner = Set{Coord}
const scannerdata = open("input", "r") do io
    result = Scanner[]
    current = Scanner()
    readline(io)
    for line ∈ eachline(io)
        isempty(line) && continue
        if contains(line, "---")
            push!(result, current)
            current = Scanner()
            continue
        end
        push!(current, eval(Meta.parse(line)))
    end
    push!(result, current)
    return result
end
const numscanners = length(scannerdata)

struct Rel
    rot::Int
    shift::Coord
end
const rotates = [
    ((x, y, z)::Coord) -> (x, y, z), ((x, y, z)::Coord) -> (x, y, -z), ((x, y, z)::Coord) -> (x, -y, z), ((x, y, z)::Coord) -> (x, -y, -z), ((x, y, z)::Coord) -> (-x, y, z), ((x, y, z)::Coord) -> (-x, y, -z), ((x, y, z)::Coord) -> (-x, -y, z), ((x, y, z)::Coord) -> (-x, -y, -z),
    ((x, y, z)::Coord) -> (x, z, y), ((x, y, z)::Coord) -> (x, z, -y), ((x, y, z)::Coord) -> (x, -z, y), ((x, y, z)::Coord) -> (x, -z, -y), ((x, y, z)::Coord) -> (-x, z, y), ((x, y, z)::Coord) -> (-x, z, -y), ((x, y, z)::Coord) -> (-x, -z, y), ((x, y, z)::Coord) -> (-x, -z, -y),
    ((x, y, z)::Coord) -> (y, x, z), ((x, y, z)::Coord) -> (y, x, -z), ((x, y, z)::Coord) -> (y, -x, z), ((x, y, z)::Coord) -> (y, -x, -z), ((x, y, z)::Coord) -> (-y, x, z), ((x, y, z)::Coord) -> (-y, x, -z), ((x, y, z)::Coord) -> (-y, -x, z), ((x, y, z)::Coord) -> (-y, -x, -z),
    ((x, y, z)::Coord) -> (y, z, x), ((x, y, z)::Coord) -> (y, z, -x), ((x, y, z)::Coord) -> (y, -z, x), ((x, y, z)::Coord) -> (y, -z, -x), ((x, y, z)::Coord) -> (-y, z, x), ((x, y, z)::Coord) -> (-y, z, -x), ((x, y, z)::Coord) -> (-y, -z, x), ((x, y, z)::Coord) -> (-y, -z, -z),
    ((x, y, z)::Coord) -> (z, x, y), ((x, y, z)::Coord) -> (z, x, -y), ((x, y, z)::Coord) -> (z, -x, y), ((x, y, z)::Coord) -> (z, -x, -y), ((x, y, z)::Coord) -> (-z, x, y), ((x, y, z)::Coord) -> (-z, x, -y), ((x, y, z)::Coord) -> (-z, -x, y), ((x, y, z)::Coord) -> (-z, -x, -y),
    ((x, y, z)::Coord) -> (z, y, x), ((x, y, z)::Coord) -> (z, y, -x), ((x, y, z)::Coord) -> (z, -y, x), ((x, y, z)::Coord) -> (z, -y, -x), ((x, y, z)::Coord) -> (-z, y, x), ((x, y, z)::Coord) -> (-z, y, -x), ((x, y, z)::Coord) -> (-z, -y, x), ((x, y, z)::Coord) -> (-z, -y, -x),
]
const numrotates = length(rotates)
apply(c::Coord, r::Rel) = rotates[r.rot](c) .+ r.shift
apply(s::Scanner, r::Rel) = s |> @map(apply(_, r)) |> Scanner
apply(x, rs::Vector{Rel}) = reduce(apply, rs; init=x)
origin(r) = apply((0,0,0), r)
function bestrel(s1::Scanner, s2::Scanner)
    rels = [Rel(rot, rotates[rot](negate(b2)) .+ b1) for b1 ∈ s1 for b2 ∈ s2 for rot ∈ 1:numrotates]
    o = argmax(x->x.second, counter(rels))
    return o.second < 12 ? nothing : o.first
end

const MaybeRel = Union{Nothing, Rel, Vector{Rel}}
rels = Dict{Int, MaybeRel}([j => bestrel(scannerdata[1], scannerdata[j]) for j ∈ 2:numscanners])
relcache = Dict{Tuple{Int, Int}, MaybeRel}()
while any(isnothing, values(rels))
    for i=2:numscanners
        !isnothing(rels[i]) && continue
        for j=2:numscanners
            (isnothing(rels[j]) || i == j) && continue
            r = get!(()->bestrel(scannerdata[j], scannerdata[i]), relcache, (j, i))
            if !isnothing(r)
                rels[i] = vcat(r, rels[j])
            end
        end
    end
end
rels[1] = Rel(1, (0,0,0))

allbeacons = mapreduce(s->apply(scannerdata[s], rels[s]), ∪, 1:numscanners)
display(length(allbeacons))

scannerpositions = map(origin, values(rels))
manhattan(o1, o2) = sum(abs.(o1 .- o2))
display(Iterators.product(scannerpositions, scannerpositions) |> @map(manhattan(_[1], _[2])) |> maximum)
