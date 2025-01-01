include("common.jl")

mutable struct Map
    pos::CartesianIndex{2}
    boxes::Set{CartesianIndex{2}}
    walls::Set{CartesianIndex{2}}
end

function process_input(input, part2)
    map_str, moves = split(input, "\n\n")

    if part2
        map_str = replace(map_str, "#" => "##", "O" => "[]", "." => "..", "@" => "@.")
    end
    
    mat = reduce(hcat, collect(line) for line in split(map_str, "\n"))
    pos = findfirst(x -> x == '@', mat)
    boxes = Set(findall(x -> x in ('[', 'O'), mat))
    walls = Set(findall(x -> x == '#', mat))

    return Map(pos, boxes, walls), replace(moves, "\n" => "")
end

function make_move!(Map, dir, part2)
    end_pos = Map.pos + dir
    while end_pos in Map.boxes
        end_pos += dir
    end
    end_pos in Map.walls && return

    Map.pos += dir
    if Map.pos in Map.boxes
        delete!(Map.boxes, Map.pos)
        push!(Map.boxes, end_pos)
    end
end

gps_score(map::Map) = sum(100 * (box.I[2] - 1) + (box.I[1] - 1) for box in map.boxes)

function part_a(input)
    map, moves = process_input(input, false)
    move2dir = Dict('<' => CartesianIndex(-1, 0),
               '>' => CartesianIndex(1, 0),
               '^' => CartesianIndex(0, -1),
               'v' => CartesianIndex(0, 1))
    for move in moves
        make_move!(map, move2dir[move], false)
    end
    return gps_score(map)
end

function part_b(input)
    map, moves = process_input(input, true)
    move2dir = Dict('<' => CartesianIndex(-1, 0),
                    '>' => CartesianIndex(1, 0),
                    '^' => CartesianIndex(0, -1),
                    'v' => CartesianIndex(0, 1))
    for move in moves
        make_move!(map, move2dir[move], true)
    end
    return gps_score(map)

    return false
end

input = read_day(15)
println(part_a(input))
println(part_b(input))
