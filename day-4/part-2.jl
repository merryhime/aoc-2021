function main()
    input = readlines("input")

    order = parse.(Int64, split(input[1], ","))
    boards = reshape(parse.(Int64, split(strip(reduce((a, b) -> string(a, " ", b), input[2:end])))), 5, 5, :)

    hits = BitArray(undef, size(boards))
    hits[:,:,:] .= false

    finalval = -1

    for val in order
        hits = hits .|| (boards .== val)

        if any(sum(hits, dims=1) .== 5) || any(sum(hits, dims=2) .== 5)
            if size(boards, 3) == 1
                b = boards[:,:,1]
                h = hits[:,:,1]
                s = sum(b[.!h])
                display(val * s)
                break
            end

            index = sum(sum(hits, dims=1) .== 5, dims=2) + sum(sum(hits, dims=2) .== 5, dims=1)
            index = index .>= 1
            index = reshape(index, :)

            boards = boards[:,:,.!index]
            hits = hits[:,:,.!index]
        end
    end
end

main()
