getinput() = readlines("input") |> @map(hcat(collect(_)...)) |> x->vcat(x...)

function step(m)
    sz = size(m)
    out = fill('.', sz)

    for row = 1:sz[1]
        for col = 1:sz[2]
            if m[row, col] == '>' && m[row, col % sz[2] + 1] == '.'
                out[row, col % sz[2] + 1] = '>'
            elseif m[row, col] == '>'
                out[row, col] = '>'
            elseif m[row, col] == 'v'
                out[row, col] = 'v'
            end
        end
    end

    m = out
    out = fill('.', sz)

    for col = 1:sz[2]
        for row = 1:sz[1]
            if m[row, col] == 'v' && m[row % sz[1] + 1, col] == '.'
                out[row % sz[1] + 1, col] = 'v'
            elseif m[row, col] == 'v'
                out[row, col] = 'v'
            elseif m[row, col] == '>'
                out[row, col] = '>'
            end
        end
    end

    return out
end

function part1()
    input = getinput()
    i = 0
    while true
        i += 1
        next = step(input)
        if next == input
            display(i)
            break
        end
        input = next
    end
end
