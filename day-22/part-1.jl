using Query

input = (readlines("input") |>
         @map(match(r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$", _).captures) |>
         @map((_[1], parse.(Int, _[2:7]))) |>
         collect)

mutable struct State
    x_axis::Vector{Int}
    y_axis::Vector{Int}
    z_axis::Vector{Int}
    on::Dict{Tuple{Int,Int,Int},Bool}
end

@inline function insert_axis!(on::Dict{Tuple{Int,Int,Int},Bool}, ai::Vector{Int}, value::Int, aj::Vector{Int}, ak::Vector{Int}, select)
    value ∈ ai && return
    i = something(findfirst(ai .> value), length(ai) + 1)
    splice!(ai, i:i-1, value)
    old = get(ai, i-1, nothing)
    if isnothing(old)
        collect(on[select(value, j, k)] = false for j ∈ aj for k ∈ ak)
    else
        collect(on[select(value, j, k)] = on[select(old, j, k)] for j ∈ aj for k ∈ ak)
    end
end

function insert_box!(state::State, box::Vector{Int}, onoff::Bool)
    insert_axis!(state.on, state.x_axis, box[1] + 0, state.y_axis, state.z_axis, (x, y, z)->(x, y, z))
    insert_axis!(state.on, state.x_axis, box[2] + 1, state.y_axis, state.z_axis, (x, y, z)->(x, y, z))
    insert_axis!(state.on, state.y_axis, box[3] + 0, state.x_axis, state.z_axis, (y, x, z)->(x, y, z))
    insert_axis!(state.on, state.y_axis, box[4] + 1, state.x_axis, state.z_axis, (y, x, z)->(x, y, z))
    insert_axis!(state.on, state.z_axis, box[5] + 0, state.x_axis, state.y_axis, (z, x, y)->(x, y, z))
    insert_axis!(state.on, state.z_axis, box[6] + 1, state.x_axis, state.y_axis, (z, x, y)->(x, y, z))
    collect(state.on[(x, y, z)] = onoff for x ∈ state.x_axis if box[1]≤x≤box[2] for y ∈ state.y_axis if box[3]≤y≤box[4] for z ∈ state.z_axis if box[5]≤z≤box[6])
end

function box_size(state::State, box::Tuple{Int,Int,Int})
    sx = state.x_axis[findfirst(state.x_axis .> box[1])] - box[1]
    sy = state.y_axis[findfirst(state.y_axis .> box[2])] - box[2]
    sz = state.z_axis[findfirst(state.z_axis .> box[3])] - box[3]
    return sx * sy * sz
end

function part1()
    s = State([], [], [], Dict())
    for i ∈ input
        if all(-50 .≤ i[2] .≤ 50)
            insert_box!(s, i[2], i[1] == "on")
        end
    end
    display(sum(box_size(s, b.first) for b ∈ s.on if b.second))
end
