include("common.jl")

mutable struct Machine
    A::Int
    B::Int
    C::Int
    ptr::Int
    ops::Vector{Int}
    output::Vector{Int}
end

function combo(machine, val)
    val <= 3 && return val
    val == 4 && return machine.A
    val == 5 && return machine.B
    val == 6 && return machine.C
    val == 7 && return -1
end

adv!(machine, operand) = machine.A = div(machine.A, 2 ^ combo(machine, operand))
bxl!(machine, operand) = machine.B = xor(machine.B, operand)
bst!(machine, operand) = machine.B = combo(machine, operand) % 8
function jnz!(machine, operand)
    machine.A == 0 && return
    machine.ptr = operand - 2
end

bxc!(machine, operand) = machine.B = xor(machine.B, machine.C)
out!(machine, operand) = push!(machine.output, combo(machine, operand) % 8)
bdv!(machine, operand) = machine.B = div(machine.A, 2 ^ combo(machine, operand))
cdv!(machine, operand) = machine.C = div(machine.A, 2 ^ combo(machine, operand))

function advance!(machine)
    op2fn = Dict(0 => adv!,
                 1 => bxl!,
                 2 => bst!,
                 3 => jnz!,
                 4 => bxc!,
                 5 => out!,
                 6 => bdv!,
                 7 => cdv!)
    op, operand = machine.ops[machine.ptr .+ (1:2)]
    op2fn[op](machine, operand)
    machine.ptr += 2
end

halts(machine) = machine.ptr + 1 > length(machine.ops)
    
function process_input(input)
    re = r"Register A: (\d+)\nRegister B: (\d+)\nRegister C: (\d+)\n\nProgram: (.*)"
    a, b, c, ops = match(re, input).captures
    return Machine(parse(Int, a), parse(Int, b), parse(Int, c), 0, parse.(Int, split(ops, ",")), Vector{Int}())
end

function part_a(input)
    machine = process_input(input)
    while true
        if halts(machine)
            return join(machine.output, ",")
        end
        advance!(machine)
    end
end

function not_subset(a, b)
    length(a) > length(b) && return true
    for ii in 1:length(a)
        a[ii] != b[ii] && return true
    end
    return false
end

function part_b(input)
    initial_machine = process_input(input)
    initial_ops = initial_machine.ops
    A = 0
    for target in 1:length(initial_ops)
        A *= 8
        found = false
        while !found
            A += 1
            machine = deepcopy(initial_machine)
            machine.A = A
            while true
                halts(machine) && break
                advance!(machine)
                if length(machine.output) == target
                    if machine.output == initial_ops[(end - target + 1):end]
                        found = true
                        break
                    end
                end
            end
            found && break
        end
    end
    return A
end

input = read_day(17)
println(part_a(input))
println(part_b(input))
