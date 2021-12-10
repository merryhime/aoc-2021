using Underscores

function main()
    field = @_ readlines("input") |> map(parse.(Int, collect(_)), __) |> vcat(__'...)

    rotu = [ field[2:end,:]             ; fill(10, 1, size(field,2)) ]
    rotd = [ fill(10, 1, size(field,2)) ; field[1:end-1,:]           ]
    rotl = [ field[:,2:end]               fill(10, size(field,1), 1) ]
    rotr = [ fill(10, size(field,1), 1)   field[:,1:end-1]           ]

    mins = field .< rotu .&& field .< rotd .&& field .< rotl .&& field .< rotr

    display(sum(field[mins] .+ 1))
end

main()
