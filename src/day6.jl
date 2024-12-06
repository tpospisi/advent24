include("common.jl")
using ResumableFunctions

function process_input(input)
    obstructions = Set{Tuple{Int, Int}}()

    rows = split(input, "\n")
    bounds = length(rows), length(rows[1])

    start = (-1, -1)
    start_dir = (-1, 0)
    for (ix, row) in enumerate(rows)
        for (iy, char) in enumerate(row)
            if char == '#'
                push!(obstructions, (ix, iy))
            elseif char == '^'
                start = (ix, iy)
            end
        end
    end

    return start, start_dir, obstructions, bounds
end

rotate(dir) = (dir[2], -dir[1])
inbounds(pos, bounds) = all(pos .> (0, 0)) && all(pos .<= bounds)

@resumable function traverse(pos, dir, obstructions, bounds)
    while true
        if !inbounds(pos, bounds)
            break
        end
        @yield (pos, dir)
        if pos .+ dir in obstructions
            dir = rotate(dir)
        else
            pos = pos .+ dir
        end
    end
end

function loops(start_pos, start_dir, obstructions, bounds)
    visited = Set{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}}()

    prev_dir = (0, 0)
    for (pos, dir) in traverse(start_pos, start_dir, obstructions, bounds)
        if dir != prev_dir # only keep track of turns
            if (pos, dir) in visited
                return true
            end
            prev_dir = dir
            push!(visited, (pos, dir))
        end
    end
    return false
end

function part_a(input)
    start_pos, start_dir, obstructions, bounds = process_input(input)
    return length(Set(pos for (pos, dir) in traverse(start_pos, start_dir, obstructions, bounds)))
end

function part_b(input)
    start_pos, start_dir, obstructions, bounds = process_input(input)

    visited = Set{Tuple{Int, Int}}()
    added_sites = Set{Tuple{Int, Int}}()
    for (pos, dir) in traverse(start_pos, start_dir, obstructions, bounds)
        push!(visited, pos)

        new_site = pos .+ dir
        if (new_site in obstructions) || new_site in visited || !inbounds(new_site, bounds)
            continue
        end

        if loops(pos, dir, union(obstructions, Set([new_site])), bounds)
            push!(added_sites, new_site)
        end
    end
    return length(added_sites)
end

input = read_day(6)
println(part_a(input))
println(part_b(input))
