include("common.jl")

function process_input(input)
    out = []
    for line in eachsplit(input, "\n")
        left, right = split(line, ": ")
        target = parse(Int, left)
        nums = parse.(Int, split(right, " "))
        push!(out, (target, nums))
    end
    return out
end

function all_targets(nums, ops)
    outcomes = Set{Int}(nums[1])
    for el in nums[2:end]
        outcomes = reduce(union, Set(op.(outcomes, el)) for op in ops)
    end
    return outcomes
end

function part_a(input)
    pairs = process_input(input)
    ops = (+, *)
    return sum(target ∈ all_targets(nums, ops) ? target : 0 for (target, nums) in pairs)
end

concat(left, right) = parse(Int, string(left) * string(right))

function part_b(input)
    pairs = process_input(input)
    ops = (+, *, concat)
    return sum(target ∈ all_targets(nums, ops) ? target : 0 for (target, nums) in pairs)
end


input = read_day(7)
println(part_a(input))
println(part_b(input))
