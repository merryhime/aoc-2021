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

tobits(x) = @_ collect(x) |> parse.(UInt, __; base=16) |> string.(__; base=2, pad=4) |> prod
getfield(x, n) = (parse.(UInt, x[1:n]; base=2), x[n+1:end])

function parsepacket(bits)
    ver, bits = getfield(bits, 3)
    typeid, bits = getfield(bits, 3)

    if typeid == 4
        value = zero(Int64)
        cont = 1
        while cont == 1
            cont, bits = getfield(bits, 1)
            next, bits = getfield(bits, 4)
            value = (value << 4) | next
        end
        return LiteralPacket(ver, value), bits
    end

    lentype, bits = getfield(bits, 1)
    subpackets = Packet[]
    if lentype == 0
        len, bits = getfield(bits, 15)
        rem, bits = bits[1:len], bits[len+1:end]
        while !isempty(rem)
            p, rem = parsepacket(rem)
            push!(subpackets, p)
        end
    else
        len, bits = getfield(bits, 11)
        for i=1:len
            p, bits = parsepacket(bits)
            push!(subpackets, p)
        end
    end
    return OperatorPacket(ver, typeid, subpackets), bits
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
packet, _ = parsepacket(tobits(input))

display(packet)
display(Int(versionsum(packet)))
display(evaluate(packet))
