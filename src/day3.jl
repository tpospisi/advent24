using Printf

function read_day(day::Integer)
    path = joinpath(@__DIR__, "..", "data", @sprintf("day%d.txt", day))
    s = open(path, "r") do file
        read(file, String)
    end
    return chomp(s)
end

function process_input(input)
    return input
end

function part_a(input)
    reg = r"mul\((\d{1,3}),(\d{1,3})\)"
    tot = 0
    for m in eachmatch(reg, input)
        left, right = parse.(Int, m.captures)
        tot += left * right
    end
    return tot
end

function part_b(input)
    reg = r"mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\))"
    tot = 0
    enabled = true
    for m in eachmatch(reg, input)
        left, right, is_do, is_dont = m.captures
        if is_do != nothing
            enabled = true
        elseif is_dont != nothing
            enabled = false
        elseif enabled
            tot += parse(Int, right) * parse(Int, left)
        end
    end
    return tot
end

input = read_day(3)
println(part_a(input))
println(part_b(input))
