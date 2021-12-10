function main()
    input = readlines("input")
    input = replace.(input, "|" => " ")
    input = split.(input)

    sum = 0

    for i in input
        examples = i[1:10]
        test = i[11:end]

        examples = map(x -> sort(collect(x) .- 'a'), examples)
        test = map(x -> sort(collect(x) .- 'a'), test)

        seg_count = first.(size.(examples))

        one_segments = first(examples[seg_count .== 2])
        four_segments = first(examples[seg_count .== 4])
        seven_segments = first(examples[seg_count .== 3])
        eight_segments = first(examples[seg_count .== 7])

        a = first(setdiff(seven_segments, one_segments))

        three_segments = first(examples[seg_count .== 5 .&& [one_segments] .⊆ examples])
        nine_segments = first(examples[seg_count .== 6 .&& [three_segments] .⊆ examples])

        e = first(setdiff(eight_segments, nine_segments))

        two_segments = first(examples[seg_count .== 5 .&& [[e]] .⊆ examples])
        five_segments = first(examples[seg_count .== 5 .&& examples .!= [two_segments] .&& examples .!= [three_segments]])
        six_segments = first(examples[seg_count .== 6 .&& [five_segments] .⊆ examples .&& examples .!= [nine_segments]])

        zero_segments = first(examples[seg_count .== 6 .&& examples .!= [nine_segments] .&& examples .!= [six_segments]])

        seglookup = [zero_segments, one_segments, two_segments, three_segments, four_segments, five_segments, six_segments, seven_segments, eight_segments, nine_segments]

        test = map(x -> findfirst(seglookup .== Ref(x)) - 1, test)
        value = test[1] * 1000 + test[2] * 100 + test[3] * 10 + test[4]

        sum += value
    end

    display(sum)
end

main()
