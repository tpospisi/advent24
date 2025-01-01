include("common.jl")
using Memoization

function process_input(input)
    instructions, patterns = split(input, "\n\n")
    return split(instructions, ", "), split(patterns, "\n")
end

@memoize function solutions(pattern, instructions)
    length(pattern) == 0 && return 1
    tot = 0
    for part in instructions
        length(pattern) < length(part) && continue
        if pattern[1:length(part)] == part
            tot += solutions(pattern[(length(part)+1):end], instructions)
        end
    end
    return tot
end

function part_a(input)
    instructions, patterns = process_input(input)
    return count(solutions(pattern, instructions) > 0 for pattern in patterns)
end

function part_b(input)
    instructions, patterns = process_input(input)
    return sum(solutions(pattern, instructions) for pattern in patterns)
end

input = read_day(19)
println(part_a(input))
println(part_b(input))
