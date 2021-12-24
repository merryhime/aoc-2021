const z_div = [1, 1, 1, 1, 26, 1, 26, 26, 1, 26, 1, 26, 26, 26]
const x_add = [10, 15, 14, 15, -8, 10, -16, -4, 11, -3, 12, -7, -15, -7]
const y_add = [2, 16, 9, 0, 1, 12, 6, 6, 3, 5, 9, 3, 2, 3]

function digit1(i, w, z)
    x = 0
    x += z
    x %= 26
    z ÷= z_div[i]
    x += x_add[i]
    x = x == w ? 1 : 0
    x = x == 0 ? 1 : 0
    y = 0
    y += 25
    y *= x
    y += 1
    z *= y
    y = 0
    y += w
    y += y_add[i]
    y *= x
    z += y
    return z
end

function digit2(i, w, z)
    x = (z % 26) + x_add[i]
    z ÷= z_div[i]
    if x != w
        z = z*26 + w + y_add[i]
    end
    return z
end

function digit3(i, w, z)
    x = last(z) + x_add[i]
    z_div[i] == 26 && pop!(z)
    if x != w
        push!(z, w + y_add[i])
    end
    return z
end

# push and pops line up:
# 1=14 2=13 3=8 4=5 6=7 9=10 11=12

# therefore:
# model[1] + y_add[1] + x_add[14] == model[14]
# model[2] + y_add[2] + x_add[13] == model[13]
# model[3] + y_add[3] + x_add[8] == model[8]
# model[4] + y_add[4] + x_add[5] == model[5]
# model[6] + y_add[6] + x_add[7] == model[7]
# model[9] + y_add[9] + x_add[10] == model[10]
# model[11] + y_add[11] + x_add[12] == model[12]

# subsitute:
# model[1] + 2 - 7 == model[14]
# model[2] + 16 - 15 == model[13]
# model[3] + 9 - 4 == model[8]
# model[4] + 0 - 8 == model[5]
# model[6] + 12 - 16 == model[7]
# model[9] + 3 - 3 == model[10]
# model[11] + 9 - 7 == model[12]

# simplify:
# model[1] - 5 == model[14]
# model[2] + 1 == model[13]
# model[3] + 5 == model[8]
# model[4] - 8 == model[5]
# model[6] - 4 == model[7]
# model[9] + 0 == model[10]
# model[11] + 2 == model[12]

# solving for maximum by hand for part 1:

model = zeros(Int, 14)
model[1] = 9; model[14] = model[1] - 5
model[2] = 8; model[13] = model[2] + 1
model[3] = 4; model[8] = model[3] + 5
model[4] = 9; model[5] = model[4] - 8
model[6] = 9; model[7] = model[6] - 4
model[9] = 9; model[10] = model[9] + 0
model[11] = 7; model[12] = model[11] + 2

function verify(w)
    z = [0]
    for i=1:14
        z = digit3(i, w[i], z)
    end
    return z
end

display((verify(model)))
display(model')

# solving for minimum by hand for part 2:

model = zeros(Int, 14)
model[1] = 6; model[14] = model[1] - 5
model[2] = 1; model[13] = model[2] + 1
model[3] = 1; model[8] = model[3] + 5
model[4] = 9; model[5] = model[4] - 8
model[6] = 5; model[7] = model[6] - 4
model[9] = 1; model[10] = model[9] + 0
model[11] = 1; model[12] = model[11] + 2

display((verify(model)))
display(model')
