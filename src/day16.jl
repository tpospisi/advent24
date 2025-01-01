include("common.jl")
using DataStructures

struct Map
    start::CartesianIndex{2}
    finish::CartesianIndex{2}
    walls::Set{CartesianIndex{2}}
end

struct State
    cur::CartesianIndex{2}
    dir::CartesianIndex{2}
end

struct SearchNode
    state::State
    cost::Int
    history::Vector{State}
end

function Base.isless(a::SearchNode, b::SearchNode)
    return a.cost < b.cost
end

function process_input(input)
    mat = reduce(hcat, collect(line) for line in split(input, "\n"))

    start = findfirst(x -> x == 'S', mat)
    finish = findfirst(x -> x == 'E', mat)
    walls = Set(findall(x -> x == '#', mat))

    return Map(start, finish, walls)
end

left_rotate(dir) = CartesianIndex(-dir.I[2], dir.I[1])
right_rotate(dir) = CartesianIndex(dir.I[2], -dir.I[1])

function neighbors(map::Map, state::State)
    moves = Tuple{State, Int}[]
    if !(state.cur + state.dir in map.walls)
        push!(moves, (State(state.cur + state.dir, state.dir), 1))
    end
    push!(moves, (State(state.cur, left_rotate(state.dir)), 1000))
    push!(moves, (State(state.cur, right_rotate(state.dir)), 1000))
    return moves
end

function part_a(input)
    map = process_input(input)

    initial_state = State(map.start, CartesianIndex(1, 0))
    search_nodes = SortedSet([SearchNode(initial_state, 0, Vector{State}())])
    visited = Set{State}()

    while true
        node = pop!(search_nodes)
        node.state in visited && continue
        node.state.cur == map.finish && return node.cost
        push!(visited, node.state)
        for (neighbor, add_cost) in neighbors(map, node.state)
            push!(search_nodes, SearchNode(neighbor, node.cost + add_cost, [node.history; neighbor]))
        end
    end
end

function part_b(input)
    map = process_input(input)

    initial_state = State(map.start, CartesianIndex(1, 0))
    search_nodes = SortedSet([SearchNode(initial_state, 0, State[initial_state])])
    visited = Dict{State, Int}()
    easy_tiles = Set{CartesianIndex{2}}()

    min_cost = typemax(Int)
    while true
        node = pop!(search_nodes)
        node.state in keys(visited) && node.cost > visited[node.state] && continue
        visited[node.state] = node.cost
        node.cost > min_cost && return length(easy_tiles)
        if node.state.cur == map.finish
            min_cost = node.cost
            for state in node.history
                push!(easy_tiles, state.cur)
            end
            continue
        end

        for (neighbor, add_cost) in neighbors(map, node.state)
            push!(search_nodes, SearchNode(neighbor, node.cost + add_cost, [copy(node.history); neighbor]))
        end
    end
end

input = read_day(16)
println(part_a(input))
println(part_b(input))
