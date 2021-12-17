using Query

input = read("input", String) |> strip
xmin, xmax, ymin, ymax = [parse(Int, m.match) for m ∈ eachmatch(r"(-?[0-9]+)", input)]
vxmax, vymax = max(abs(xmin), abs(xmax)), max(abs(ymin), abs(ymax))

inarea((x, y)) = xmin::Int ≤ x ≤ xmax::Int && ymin::Int ≤ y ≤ ymax::Int
outofrange((x, y)) = x > xmax::Int || y < ymin::Int
step((x, y, vx, vy)) = (x + vx, y + vy, vx - sign(vx), vy - 1)
maxh(vy) = sum(1:vy)

function maxheight(vx, vy)
    s = (0, 0, vx, vy)
    while !inarea(s) && !outofrange(s)
        s = step(s)
    end
    return inarea(s) ? maxh(vy) : missing
end

part1 = (maxheight(vx, vy) for vy ∈ vymax:-1:-vymax for vx ∈ 0:vxmax) |> skipmissing |> first
part2 = (maxheight(vx, vy) for vy ∈ vymax:-1:-vymax for vx ∈ 0:vxmax) |> skipmissing |> @map(1) |> sum
