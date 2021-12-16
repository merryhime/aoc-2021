using Underscores, Query

abstract type Packet end
struct LiteralPacket <: Packet
    version::UInt8
    value::Int64
end
struct OperatorPacket <: Packet
    version::UInt8
    typeid::UInt8
    subpackets::Vector{Packet}
end

mutable struct Stream
    bits::String
end
function getfield!(s::Stream, n)
    x, s.bits = parse.(UInt, s.bits[1:n]; base=2), s.bits[n+1:end]
    return x
end
ts(x) = @_ collect(x) |> parse.(UInt, __; base=16) |> string.(__; base=2, pad=4) |> prod |> Stream

function parsepacket(s)
    ver, typeid = getfield!(s, 3), getfield!(s, 3)

    if typeid == 4
        value, cont = zero(Int64), 1
        while cont == 1
            cont = getfield!(s, 1)
            value = (value << 4) | getfield!(s, 4)
        end
        return LiteralPacket(ver, value)
    end

    if getfield!(s, 1) == 0
        len = getfield!(s, 15)
        rem, s.bits = Stream(s.bits[1:len]), s.bits[len+1:end]
        subpackets = Packet[]
        while !isempty(rem.bits)
            push!(subpackets, parsepacket(rem))
        end
    else
        len = getfield!(s, 11)
        subpackets = [parsepacket(s) for i=1:len]
    end
    return OperatorPacket(ver, typeid, subpackets)
end

function versionsum(packet)
    packet isa LiteralPacket && return packet.version
    return packet.version + (packet.subpackets |> @map(versionsum(_)) |> sum)
end

function evaluate(packet)
    packet isa LiteralPacket && return packet.value
    op = [sum, prod, minimum, maximum, nothing, ((a,b),)->a>b, ((a,b),)->a<b, ((a,b),)->a==b]
    return packet.subpackets |> @map(evaluate(_)) |> op[packet.typeid + 1]
end

input = read("input", String) |> strip
packet = parsepacket(ts(input))

display(packet)
display(Int(versionsum(packet)))
display(evaluate(packet))
