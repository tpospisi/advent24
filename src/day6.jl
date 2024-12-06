include("common.jl")
using ResumableFunctions

function process_input(input)
    mat = permutedims(reduce(hcat, collect.(eachsplit(input, "\n"))))

    obstructions = Set(findall(mat .== '#'))
    start = findfirst(mat .== '^')
    start_dir = CartesianIndex(-1, 0)
    bounds = axes(mat)

    return start, start_dir, obstructions, bounds
end

rotate(dir::CartesianIndex{2}) = CartesianIndex(dir[2], -dir[1])

@resumable function traverse(pos, dir, obstructions, bounds)
    while true
        if !checkindex(Bool, bounds, pos)
            break
        end
        @yield (pos, dir)
        if pos + dir in obstructions
            dir = rotate(dir)
        else
            pos += dir
        end
    end
end

function loops(start_pos, start_dir, obstructions, bounds)
    visited = Set{Tuple{CartesianIndex{2}, CartesianIndex{2}}}()

    prev_dir = CartesianIndex(0, 0)
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

    visited = Set{CartesianIndex{2}}()
    added_sites = Set{CartesianIndex{2}}()
    for (pos, dir) in traverse(start_pos, start_dir, obstructions, bounds)
        push!(visited, pos)

        new_site = pos + dir
        if (new_site in obstructions) || new_site in visited || !checkindex(Bool, bounds, new_site)
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
