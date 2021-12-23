using DataStructures

const Coord=Tuple{Int, Int}
struct State
    pos::Dict{Coord, Char}
    score::Int
end

const corridor=[(1,1) (1,2) (1,4) (1,6) (1,8) (1,10) (1,11)]
const rooms=Dict('A' => [(2,3), (3,3)],
                 'B' => [(2,5), (3,5)],
                 'C' => [(2,7), (3,7)],
                 'D' => [(2,9), (3,9)])
const cost=Dict('A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000)

iscorrdior((x,y)::Coord) = x == 1
dist(p1::Coord, p2::Coord) = sum(abs.(p1 .- p2))
canenter(s::State, c::Char) = all(get(s.pos, i, c) == c for i ∈ rooms[c])
canleave(s::State, c::Char, from::Coord) = !(from ∈ rooms[c] && all(get(s.pos, i, c) == c for i ∈ rooms[c]))
isdone(s::State) = all(i.first ∈ rooms[i.second] for i ∈ s.pos)

function canmove(s::State, from::Coord, to::Coord)
    range(a, b) = a < b ? (a:b-1) : (b+1:a)
    from[2] == to[2] && return false
    any((1, i) ∈ keys(s.pos) for i ∈ range(to[2], from[2])) && return false
    !iscorrdior(to) && any((i, to[2]) ∈ keys(s.pos) for i ∈ range(to[1], 1)) && return false
    !iscorrdior(from) && any((i, from[2]) ∈ keys(s.pos) for i ∈ range(1, from[1])) && return false
    return true
end

function move(s::State, from::Coord, to::Coord)
    newpos = deepcopy(s.pos)
    c = newpos[from]
    delete!(newpos, from)
    newpos[to] = c
    return State(newpos, s.score + dist(from, to) * cost[c])
end

#  #############
#  #...........#
#  ###B#C#B#D###
#    #A#D#C#A#
#    #########
const test=Dict((2,3) => 'B', (3,3) => 'A',
                (2,5) => 'C', (3,5) => 'D',
                (2,7) => 'B', (3,7) => 'C',
                (2,9) => 'D', (3,9) => 'A')

#  #############
#  #...........#
#  ###D#B#C#A###
#    #C#A#D#B#
#    #########
const input=Dict((2,3) => 'D', (3,3) => 'C',
                 (2,5) => 'B', (3,5) => 'A',
                 (2,7) => 'C', (3,7) => 'D',
                 (2,9) => 'A', (3,9) => 'B')

function gennext(s::State)
    nexts = State[]
    for (from, c) ∈ s.pos
        if iscorrdior(from) && canenter(s, c)
            for to ∈ rooms[c]
                canmove(s, from, to) && push!(nexts, move(s, from, to))
            end
        end
        if !iscorrdior(from) && canleave(s, c, from)
            for to ∈ corridor
                canmove(s, from, to) && push!(nexts, move(s, from, to))
            end
        end
    end
    return nexts
end

function search(start)
    openset = PriorityQueue{State, Int}()
    openset[start] = start.score
    prev = Dict{Dict{Tuple{Int, Int}, Char}, Int}()
    step = Dict{State, State}()
    while true
        current = dequeue!(openset)
        if isdone(current)
            path = [current]
            while last(path) ∈ keys(step)
                push!(path, step[last(path)])
            end
            return current, reverse(path)
        end
        for n ∈ gennext(current)
            if n.pos ∉ keys(prev) || n.score < prev[n.pos]
                step[n] = current
                prev[n.pos] = n.score
                openset[n] = n.score
            end
        end
    end
end

function printstate(state)
    for j=1:3
        for i=1:11
            print(get(state.pos, (j,i), ' '))
        end
        print("\n")
    end
    display(state.score)
end

@assert search(State(test, 0))[1].score == 12521

function part1()
    display(search(State(input, 0))[1].score)
end
