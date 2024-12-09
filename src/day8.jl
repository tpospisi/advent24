include("common.jl")
using DataStructures
using Combinatorics

function process_input(input)
    mat = permutedims(reduce(hcat, collect.(eachsplit(input, "\n"))))
    bounds = axes(mat)

    antenna_locs = DefaultDict{Char, Set{CartesianIndex{2}}}(() -> Set{CartesianIndex{2}}())
    for idx in findall(mat .!= '.')
        push!(antenna_locs[mat[idx]], idx)
    end

    return antenna_locs, bounds
end

function part_a(input)
    antenna_locs, bounds = process_input(input)

    antinodes = Set{CartesianIndex{2}}()
    for (_, locs) in antenna_locs
        for (left, right) in combinations(collect(locs), 2)
            antipod = left + (left - right)
            if checkindex(Bool, bounds, antipod)
                push!(antinodes, antipod)
            end

            antipod = right + (right - left)
            if checkindex(Bool, bounds, antipod)
                push!(antinodes, antipod)
            end

        end
    end

    return length(antinodes)
end

least_form(idx) = CartesianIndex(Tuple(div(el,gcd(idx.I...)) for el in idx.I))

function part_b(input)
    antenna_locs, bounds = process_input(input)

    antinodes = Set{CartesianIndex{2}}()
    for (_, locs) in antenna_locs
        for (left, right) in combinations(collect(locs), 2)
            step = least_form(right - left)
            antipod = left
            while checkindex(Bool, bounds, antipod)
                push!(antinodes, antipod)
                antipod += step
            end

            antipod = left
            while checkindex(Bool, bounds, antipod)
                push!(antinodes, antipod)
                antipod -= step
            end
        end
    end

    return length(antinodes)

    return false
end


input = read_day(8)
println(part_a(input))
println(part_b(input))
