include("common.jl")
using Memoization

function process_input(input)
    return parse.(Int, split(input, " "))
end

function even_digits(stone)
    return length(string(stone)) % 2 == 0
end

function halve(stone)
    str = string(stone)
    return parse(Int, str[1:div(length(str), 2)]), parse(Int, str[(div(length(str), 2)+1):end])
end

@memoize function children(stone, next_steps)
    next_steps == 0 && return 1
    stone == 0 && return children(1, next_steps - 1)
    !even_digits(stone) && return children(stone * 2024, next_steps - 1)
    left, right = halve(stone)
    return children(left, next_steps - 1) + children(right, next_steps - 1)
end

function part_a(input)
    stones = process_input(input)
    return sum(children(stone, 25) for stone in stones)
end

function part_b(input)
    stones = process_input(input)
    return sum(children(stone, 75) for stone in stones)
end

input = read_day(11)
println(part_a(input))
println(part_b(input))
