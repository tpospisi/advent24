include("common.jl")

function process_input(input)
    mat = reduce(hcat, map(x -> parse.(Int, x), collect.(eachsplit(input, "\n"))))
    trailheads = findall(mat .== 0)
    return mat, trailheads
end

function neigbhors(mat, point)
    dirs = CartesianIndex.(((-1, 0),(1,0),(0,-1),(0,1)))
    return filter(x -> checkbounds(Bool, mat, x), [point + dir for dir in dirs])
end

function score_trailhead(mat, trailhead)
    paths = [[trailhead]]

    destinations = Set{CartesianIndex{2}}()
    score = 0

    while !isempty(paths)
        path = pop!(paths)
        if length(path) == 10
            score += 1
            push!(destinations, path[end])
            continue
        end
        for neighbor in neigbhors(mat, path[end])
            if mat[neighbor] == mat[path[end]] + 1
                push!(paths, [path; neighbor])
            end
        end
    end
    return length(destinations), score
end

function part_a(input)
    mat, trailheads = process_input(input)
    return sum(score_trailhead(mat, trailhead)[1] for trailhead in trailheads)
end

function part_b(input)
    mat, trailheads = process_input(input)
    return sum(score_trailhead(mat, trailhead)[2] for trailhead in trailheads)
end

input = read_day(10)
println(part_a(input))
println(part_b(input))
