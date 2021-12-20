using Query

iea, _, field = open("input", "r") do io
    collect(readline(io)) .== '#',
    readline(io), # skip line
    eachline(io) |> @map(collect(_) .== '#') |> x->hcat(x...)'
end
image = (f=field, i=false)

rotu(f, i) = [f[2:end,:]           ; fill(i, 1, size(f,2))]
rotd(f, i) = [fill(i, 1, size(f,2)); f[1:end-1,:]         ]
rotl(f, i) = [f[:,2:end]             fill(i, size(f,1), 1)]
rotr(f, i) = [fill(i, size(f,1), 1)  f[:,1:end-1]         ]
expand((f, i),) = (f=[fill(i, size(f,1)+2, 1) [fill(i, 1, size(f,2)); f; fill(i, 1, size(f,2))] fill(i, size(f,1)+2, 1)], i=i)
indexes((f, i),) = 1 .+ sum([rotd(rotr(f, i), i), rotd(f, i), rotd(rotl(f, i), i),
                                  rotr(f, i),          f,          rotl(f, i),
                             rotu(rotr(f, i), i), rotu(f, i), rotu(rotl(f, i), i)] .* [256, 128, 64, 32, 16, 8, 4, 2, 1])
apply(im) = (f=map(x->map(y->iea[y], x), indexes(expand(im))), i=im.i ? iea[512] : iea[1])

function run(n)
    im = deepcopy(image)
    for i=1:n
        im = apply(im)
    end
    display(count(im.f))
end

run(2)
run(50)
