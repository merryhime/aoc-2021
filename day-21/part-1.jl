using Query

mutable struct DeterministicDie
    state::Int
end
roll(d::DeterministicDie) = d.state += 1

mutable struct Player
    score::Int
    position::Int
end

function play(boardsize, players, die)
    while true
        for i = 1:length(players)
            rolls = sum(roll(die) for j=1:3)
            players[i].position = (players[i].position + rolls - 1) % boardsize + 1
            players[i].score += players[i].position
            players[i].score ≥ 1000 && return
        end
    end
end

function input()
    return readlines("input") |> @map(parse(Int, match(r"Player \d starting position: (\d+)", _)[1])) |> @map(Player(0, _)) |> collect
end

function part1()
    die = DeterministicDie(0)
    players = input()
    play(10, players, die)
    display(die.state * minimum(p->p.score, players))
end
