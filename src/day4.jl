include("common.jl")

function process_input(input)
    return reduce(hcat, collect.(eachsplit(input, "\n")))
end

check_match(mat, point, char) = checkbounds(Bool, mat, point) && mat[point] == char

function word_search(mat, patterns)
    finds = 0
    for origin in CartesianIndices(mat), pattern in patterns
        finds += all(check_match(mat, origin + diff, char) for (diff, char) in pattern)
    end
    return finds
end


function part_a(input)
    mat = process_input(input)

    dirs = CartesianIndex.(((0, 1), (1, 1), (-1, 1),
                           (0, -1), (1, -1), (-1, -1),
                           (1,0), (-1, 0)))
    patterns = (((step .* dir, "XMAS"[step + 1]) for step = 0:3) for dir in dirs)

    return word_search(mat, patterns)
end

function part_b(input)
    mat = process_input(input)

    patterns = (((CartesianIndex(-1, -1), c1),
                 (CartesianIndex(1, -1), c2),
                 (CartesianIndex(0, 0), 'A'),
                 (CartesianIndex(1, 1), c1 == 'S' ? 'M' : 'S'),
                 (CartesianIndex(-1, 1), c2 == 'S' ? 'M' : 'S'))
                for c1 in ('M', 'S'), c2 in ('M', 'S'))

    return word_search(mat, patterns)
end

input = read_day(4)
println(part_a(input))
println(part_b(input))
