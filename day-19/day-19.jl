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
    for r ∈ 1:numrotates
        rot = @inbounds rotates[r]
        as2 = @. rot(negate(s2))
        c = counter(b2 .+ b1 for b1 ∈ s1 for b2 ∈ as2)
        o = argmax(x->x.second, c)
        o.second ≥ 12 && return Rel(r, o.first)
    end
    return nothing
end

const MaybeRel = Union{Nothing, Rel, Vector{Rel}}
function getrels()
    rels = Dict{Int, MaybeRel}([j => bestrel(scannerdata[1], scannerdata[j]) for j ∈ 2:numscanners])
    relcache = Dict{Tuple{Int, Int}, MaybeRel}()
    while any(isnothing, values(rels))
        for i=2:numscanners
            isnothing(rels[i]) && continue
            for j=2:numscanners
                (!isnothing(rels[j]) || i == j) && continue
                r = get!(()->bestrel(scannerdata[i], scannerdata[j]), relcache, (i, j))
                if !isnothing(r)
                    rels[j] = vcat(r, rels[i])
                    break
                end
            end
        end
    end
    rels[1] = Rel(1, (0,0,0))
    return rels
end

function main()
    rels = getrels()

    allbeacons = mapreduce(s->apply(scannerdata[s], rels[s]), ∪, 1:numscanners)
    display(length(allbeacons))

    scannerpositions = map(origin, values(rels))
    manhattan(o1, o2) = sum(abs.(o1 .- o2))
    display(Iterators.product(scannerpositions, scannerpositions) |> @map(manhattan(_[1], _[2])) |> maximum)
end

main()
