function main()
    input = read("input", String)
    input = split.(strip(input), ",")
    input = parse.(Int64, input)
    input .+= 1

    state = [0,0,0,0,0,0,0,0,0]

    state = sum(input' .== 1:9, dims=2)[:]

    for day = 1:256
        births = first(state)
        state = circshift(state, -1)
        state[7] += births
    end

    display(sum(state))
end

main()
