include("common.jl")
using DataStructures

struct Map
    start::CartesianIndex{2}
    finish::CartesianIndex{2}
    walls::Set{CartesianIndex{2}}
end

State = CartesianIndex{2}

struct SearchNode
    state::State
    history::Vector{State}
    cost::Int
end

function Base.isless(a::SearchNode, b::SearchNode)
    return a.cost < b.cost
end

function process_input(input)
    start = CartesianIndex(0, 0)
    finish = CartesianIndex(70, 70)
    walls = Vector{CartesianIndex{2}}()

    lines = split(input, "\n")
    for sub_st in lines
        push!(walls, CartesianIndex(parse.(Int, split(sub_st, ","))...))
    end

    return start, finish, walls
end

function is_open(idx, map)
    (any(idx.I .< 0) || any(idx.I .> map.finish.I)) && return false
    return !(idx in map.walls)
end


function neighbors(map::Map, state::State)
    moves = Tuple{State, Int}[]
    for dir in CartesianIndex.([(0,1), (0,-1), (1,0), (-1, 0)])
        new_cur = state .+ dir
        if is_open(new_cur, map)
            push!(moves, (State(new_cur), 1))
        end
    end
    return moves
end

function search(map)    
    initial_state = State(map.start)
    search_nodes = SortedSet([SearchNode(initial_state, [initial_state], 0)])
    visited = Set{State}()

    while !isempty(search_nodes)
        node = pop!(search_nodes)
        node.state in visited && continue
        node.state == map.finish && return true, node.history
        push!(visited, node.state)
        for (neighbor, add_cost) in neighbors(map, node.state)
            push!(search_nodes, SearchNode(neighbor, [node.history; neighbor], node.cost + add_cost))
        end
    end

    return false, Vector{State}()
end

function part_a(input)
    start, finish, walls = process_input(input)
    map = Map(start, finish, Set(walls[1:1024]))
    _, hist = search(map)
    return length(hist) - 1
end

function part_b(input)
    start, finish, full_walls = process_input(input, typemax(Int))
    ctr = 1024
    while true
        map = Map(start, finish, Set(full_walls[1:ctr]))
        reachable, hist = search(map)
        if !reachable
            last = full_walls[ctr].I
            return "$(last[1]),$(last[2])"
        end
        ctr = findfirst(x -> x in hist, full_walls)
    end
    return false
end

input = read_day(18)
println(part_a(input))
println(part_b(input))
