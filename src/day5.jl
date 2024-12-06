include("common.jl")
using DataStructures

function process_input(input)
    rules_str, seqs_str = split(input, "\n\n")
    rules = [parse.(Int, split(el, "|")) for el in split(rules_str, "\n")]
    rows = [parse.(Int, split(el, ",")) for el in split(seqs_str, "\n")]

    children = DefaultDict{Int, Vector{Int}}(() -> Vector{Int}())
    for (before, after) in rules
        push!(children[before], after)
    end

    return children, rows
end

function find_misorder(row, children)
    seen = Set{Int}()
    for (ix, el) in enumerate(row)
        misorderings = intersect(children[el], seen)
        if length(misorderings) > 0
            split_id = findfirst(el -> el in misorderings, row)
            return true, ix, split_id
        end
        push!(seen, el)
    end
    return false, -1, -1
end

function fix_misorder!(row, children)
    was_fixed = false
    while true
        misorder, fix_id, split_id = find_misorder(row, children)
        if misorder
            was_fixed = true
            row[split_id], row[(split_id+1):fix_id] = row[fix_id], row[split_id:(fix_id - 1)]
        else
            return was_fixed
        end
    end
end

midpoint(xx) = xx[div(length(xx) + 1, 2)]

function part_a(input)
    children, rows = process_input(input)
    return sum(find_misorder(row, children)[1] ? 0 : midpoint(row) for row in rows)
end

function part_b(input)
    children, rows = process_input(input)
    return sum(fix_misorder!(row, children) ? midpoint(row) : 0 for row in rows)
end

input = read_day(5)
println(part_a(input))
println(part_b(input))
