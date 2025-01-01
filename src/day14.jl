include("common.jl")
using DataStructures

mutable struct Robot
    pos::CartesianIndex{2}
    vel::CartesianIndex{2}
end

Robot(px::Int, py::Int, dx::Int, dy::Int) = Robot(CartesianIndex(px, py), CartesianIndex(dx, dy))

function advance!(robot::Robot, steps, grid::CartesianIndex{2})
    robot.pos += steps * robot.vel
    robot.pos = CartesianIndex(mod.(robot.pos.I, grid.I))
end

function quadrant_count(robot::Robot, grid)
    midpoints = div.(grid.I, 2)
    any(robot.pos.I .== midpoints) && return (0, 0, 0, 0)
    state2quadrant = Dict((false, false) => (0, 0, 0, 1),
                          (false, true) => (0, 0, 1, 0),
                          (true, false) => (0, 1, 0, 0),
                          (true, true) => (1, 0, 0, 0))
    return state2quadrant[robot.pos.I .> midpoints]
end

quadrant_count(robots::Vector{Robot}, grid) = reduce(.+, quadrant_count(robot, grid) for robot in robots)

function process_input(input)
    re = r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)"
    return [Robot(parse.(Int, match.captures)...) for match in eachmatch(re, input)]
end

function show(robots::Vector{Robot}, grid)
    mat = falses(grid.I)
    for robot in robots
        mat[CartesianIndex(robot.pos.I .+ (1,1))] = true
    end
    for row in eachrow(mat)
        print(join([el ? "*" : " " for el in row], ""))
        print("|\n")
    end
end

function part_a(input)
    robots = process_input(input)
    grid = CartesianIndex(101, 103)
    advance!.(robots, 100, grid)
    return prod(quadrant_count(robots, grid))
end

function part_b(input)
    robots = process_input(input)
    grid = CartesianIndex(101, 103)

    ii = 0
    maxval = part_a(input)
    while true
        ii += 1
        advance!.(robots, 1, grid)
        val = prod(quadrant_count(robots, grid))
        if val <= maxval
            show(robots, grid)
            println(ii)
            readline(stdin)
        end
    end
end

input = read_day(14)
println(part_a(input))
println(part_b(input))
