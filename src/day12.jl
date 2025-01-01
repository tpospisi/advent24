include("common.jl")

function process_input(input)
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    return data
end



function neighbors(ind)
    dirs = ((1, 0), (-1, 0), (0, 1), (0, -1))
    return ind .+ CartesianIndex.(dirs)
end

function subregion_cost!(index, visited, data, part_2)
    visited[index] && return 0
    label = data[index]
    queue = Set{CartesianIndex{2}}([index])
    exterior_cells = Set{Tuple{CartesianIndex{2},Int}}()
    area = 0
    perimeter = 0
    interior_edges = 0
    while !isempty(queue)
        ind = pop!(queue)
        visited[ind] && continue
        area += 1
        visited[ind] = true
        for (d, neighbor) in enumerate(neighbors(ind))
            if checkbounds(Bool, data, neighbor) && data[neighbor] == label
                interior_edges += 1
                !visited[neighbor] && push!(queue, neighbor)
            else
                push!(exterior_cells, (neighbor, d))
            end
        end
        end
    perimeter = 4 * area - interior_edges
    return area * (part_2 ? calculate_sides(exterior_cells) : perimeter)
end


function cost(data, part_2=false)
    visited = falses(size(data))
    return sum(subregion_cost!(ii, visited, data, part_2) for ii ∈ CartesianIndices(data))
end

function calculate_sides(exterior_cells)
    count = 0
    while !isempty(exterior_cells)
        count += 1
        queue = Tuple{CartesianIndex{2},Int}[first(exterior_cells)]
        while !isempty(queue)
            a = popfirst!(queue)
            delete!(exterior_cells, a)
            for b ∈ exterior_cells
                if a[2] == b[2] && sum(abs.((a[1] .- b[1]).I)) == 1
                    push!(queue, b)
                end
            end
        end
    end
    return count
end

function part_a(input)
    data = process_input(input)
    return cost(data, false)
end

function part_b(input)
    data = process_input(input)
    return cost(data, true)
end


input = read_day(12)
println(part_a(input))
@assert part_a(input) == 1402544
@assert part_b(input) == 862486
println(part_b(input))
