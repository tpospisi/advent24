include("common.jl")
using JuMP
using GLPK

struct Machine
    adx::Int
    ady::Int
    bdx::Int
    bdy::Int
    xpt::Int
    ypt::Int
end

function solve(machine::Machine, part2=false)
    model = Model(GLPK.Optimizer)  
    @variable(model, a_pushes >= 0, Int)
    @variable(model, b_pushes >= 0, Int)
    @objective(model, Min, 3 * a_pushes + b_pushes)
    offset = part2 ? 10000000000000 : 0
    @constraint(model, a_pushes * machine.adx + b_pushes * machine.bdx == machine.xpt + offset)
    @constraint(model, a_pushes * machine.ady + b_pushes * machine.bdy == machine.ypt + offset)
    optimize!(model)
    solved = termination_status(model) == OPTIMAL
    if !solved
        return solved, -1
    end
    return solved, Int(objective_value(model))
end

function process_input(input)
    re = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"
    return [Machine(parse.(Int, match.captures)...) for match in eachmatch(re, input)]
end

function part_a(input)
    machines = process_input(input)
    return sum(map((solved, val)::Tuple -> solved ? val : 0, solve(machine) for machine in machines))
end

function part_b(input)
    machines = process_input(input)
    return sum(map((solved, val)::Tuple -> solved ? val : 0, solve(machine, true) for machine in machines))
end

input = read_day(13)
println(part_a(input))
println(part_b(input))
