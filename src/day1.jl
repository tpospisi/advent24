using Printf
using DataStructures

function read_day(day::Integer)
    path = joinpath(@__DIR__, "..", "data", @sprintf("day%d.txt", day))
    s = open(path, "r") do file
        read(file, String)
    end
    return chomp(s)
end

function process_input(input)
    re = r"(\d+)\s+(\d+)"
    rows = [parse.(Int, m.captures) for m in eachmatch(re, input)]
    left_list = [el[1] for el in rows]
    right_list = [el[2] for el in rows]
    return left_list, right_list
end

function part_a(input)
    left_list, right_list = process_input(input)
    sort!(left_list)
    sort!(right_list)
    return sum(abs.(left_list .- right_list))
end

function part_b(input)
    left_list, right_list = process_input(input)
    counts = counter(right_list)
    return sum(el * counts[el] for el in left_list)
end

input = read_day(1)
@assert part_a(input) == 2815556
@assert part_b(input) == 23927637
