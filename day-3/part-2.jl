input = readlines("input")

m = map(x -> collect(x) .== '1', input)
m = vcat(m'...)

bits = size(m, 2)

oxy_m = deepcopy(m)
co2_m = deepcopy(m)

for i=1:bits
    oxy_mid = size(oxy_m, 1)/2
    co2_mid = size(co2_m, 1)/2

    oxy_col = oxy_m[:,i]
    co2_col = co2_m[:,i]

    oxy_sel = (sum(oxy_col) >= oxy_mid) .== oxy_col
    co2_sel = (sum(co2_col) <  co2_mid) .== co2_col

    if size(oxy_m, 1) > 1
        global oxy_m = oxy_m[oxy_sel,:]
    end
    if size(co2_m, 1) > 1
        global co2_m = co2_m[co2_sel,:]
    end
end

function ba_to_int(b)
    return sum((2 .^ collect(0:length(b)-1))[reverse(b)])
end

oxy_rating = ba_to_int(oxy_m[:])
co2_rating = ba_to_int(co2_m[:])

display(oxy_rating * co2_rating)
