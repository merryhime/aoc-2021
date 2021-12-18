using Accessors, Query

flatten(tree::Number, level=0) = (v=tree, l=level)
flatten(tree::Vector, level=0) = vcat([flatten(n, level+1) for n ∈ tree]...)

function explode(n)
    i = 1
    while i ≤ length(n)
        if n[i].l > 4
            i > 1 && (n = @set n[i-1].v += n[i].v)
            i+1 < length(n) && (n = @set n[i+2].v += n[i+1].v)
            splice!(n, i:i+1, [(v=0, l=4)])
        end
        i += 1
    end
    return n
end

function split!(n)
    i = findfirst(x->x.v≥10, n)
    !isnothing(i) && splice!(n, i:i, [(v=n[i].v÷2, l=n[i].l+1), (v=n[i].v-n[i].v÷2, l=n[i].l+1)])
    return !isnothing(i)
end

function simplify(n)
    while true
        n = explode(n)
        split!(n) || return n
    end
end

function add(a, b)
    return simplify(vcat(a, b) |> @map(@set _.l += 1) |> collect)
end

function magnitude!(n)
    for level=4:-1:1
        i = 1
        while i ≤ length(n)
            if n[i].l == level
                splice!(n, i:i+1, [(v=3*n[i].v+2*n[i+1].v, l=level-1)])
            end
            i += 1
        end
    end
    return n[1].v
end

@assert simplify(flatten([[[[[9,8],1],2],3],4])) == flatten([[[[0,9],2],3],4])
@assert simplify(flatten([[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]])) == flatten([[[[0,7],4],[[7,8],[6,0]]],[8,1]])
@assert reduce(add, [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6]] |> @map(flatten(_))) == flatten([[[[5,0],[7,4]],[5,5]],[6,6]])
@assert reduce(add, [[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]], [7,[[[3,7],[4,3]],[[6,3],[8,8]]]], [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]], [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]], [7,[5,[[3,8],[1,4]]]], [[2,[2,2]],[8,[8,1]]], [2,9], [1,[[[9,3],9],[[9,0],[0,7]]]], [[[5,[7,4]],7],1], [[[[4,2],2],6],[8,7]]] |> @map(flatten(_))) == flatten([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])
@assert magnitude!(flatten([[[[0,7],4],[[7,8],[6,0]]],[8,1]])) == 1384
@assert magnitude!(flatten([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])) == 3488

input = readlines("input") |> @map(flatten(eval(Meta.parse(_)))) |> collect
part1 = magnitude!(reduce(add, input))
part2 = Iterators.product(input, input) |> @map(magnitude!(add(_...))) |> maximum
