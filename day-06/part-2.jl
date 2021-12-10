using Underscores

function main()
    input = @_ read("input", String) |> strip(__) |> split.(__, ",") |> parse.(Int64, __)

    state = sum(input' .== 0:8, dims=2)[:]

    for day = 1:256
        births = first(state)
        state = circshift(state, -1)
        state[7] += births
    end

    display(sum(state))
end

main()
