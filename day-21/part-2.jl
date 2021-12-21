using DataStructures

mutable struct Player
    score::Int
    position::Int
    turns::Int
end
advance(pos::Int, rollsum::Int) = (pos + rollsum - 1) % 10 + 1
turn(p::Player, rollsum::Int) = Player(p.score + advance(p.position, rollsum), advance(p.position, rollsum), p.turns + 1)
iswin(p::Player) = p.score ≥ 21
iswin((p,_)::Pair{Player,Int}) = iswin(p)

reducecount(pairs) = mapreduce(x->counter(Dict([x])), merge, pairs)

const rollsums = counter([i+j+k for i ∈ 1:3 for j ∈ 1:3 for k ∈ 1:3])

function gen(p::Player)
    ps = counter([p]);
    wins = Accumulator{Player, Int64}()
    lose = Dict{Int, Accumulator{Player, Int64}}()
    turns = 1
    while !isempty(ps)
        ps = reducecount(turn(p.first, r.first) => p.second * r.second for p ∈ ps for r ∈ rollsums)
        wins = merge(wins, Accumulator(Dict(filter(iswin, ps))))
        ps = lose[turns] = Accumulator(Dict(filter(!iswin, ps)))
        turns += 1
    end
    return wins, lose
end

a_win, a_lose = gen(Player(0, 4, 0))
b_win, b_lose = gen(Player(0, 2, 0))

display(sum([w.second * l.second for w ∈ a_win for l ∈ b_lose[w.first.turns - 1]]))
display(sum([w.second * l.second for w ∈ b_win for l ∈ a_lose[w.first.turns]]))

