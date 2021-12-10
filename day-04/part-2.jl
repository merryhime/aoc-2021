using Underscores

function main()
    input = readlines("input")
    order = @_ input[1] |> split(__, ",") |> parse.(Int64, __)
    boards = @_ input[2:end] |> reduce(string(_1, " ", _2), __) |> strip |> split |> parse.(Int64, __) |> reshape(__, 5, 5, :)

    hits = falses(size(boards))

    for val in order
        hits = hits .| (boards .== val)

        wins = reshape(reduce(|, sum(hits, dims=1) .== 5; dims=2) .| reduce(|, sum(hits, dims=2) .== 5; dims=1), :)

        if any(wins)
            if size(boards, 3) == 1
                display(val * sum(boards[.!hits]))
                break
            end

            boards = boards[:,:,.!wins]
            hits = hits[:,:,.!wins]
        end
    end
end

main()
