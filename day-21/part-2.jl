using DataStructures, Query

mutable struct Player
    score::Int
    position::Int
    turns::Int
end
advance(pos::Int, rollsum::Int) = (pos + rollsum - 1) % 10 + 1
turn(p::Player, rollsum::Int) = Player(p.score + advance(p.position, rollsum), advance(p.position, rollsum), p.turns + 1)
iswin(p::Player) = p.score ≥ 21
iswin((p,_)::Pair{Player,Int64}) = iswin(p)

const rollsums = collect(counter([i+j+k for i ∈ 1:3 for j ∈ 1:3 for k ∈ 1:3]))

function gen(p::Player)
    ps = Pair{Player, Int64}[p => 1]
    wins = Pair{Player, Int64}[]
    lose = Int64[]
    while !isempty(ps)
        ps = [turn(p.first, r.first) => p.second * r.second for p ∈ ps for r ∈ rollsums]
        wins = vcat(wins, filter(iswin, ps))
        ps = collect(filter(!iswin, ps))
        push!(lose, sum(x->x.second, ps; init=0))
    end
    return wins, lose
end

input = readlines("input") |> @map(parse(Int, match(r"Player \d starting position: (\d+)", _)[1])) |> collect

a_win, a_lose = gen(Player(0, input[1], 0))
b_win, b_lose = gen(Player(0, input[2], 0))

display(sum(w.second * b_lose[w.first.turns - 1] for w ∈ a_win))
display(sum(w.second * a_lose[w.first.turns] for w ∈ b_win))
