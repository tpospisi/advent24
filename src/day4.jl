include("common.jl")
using DataStructures

function process_input(input)
    mat = DefaultDict{Tuple{Int, Int}, Char}('~')
    for (ii, row) in enumerate(eachsplit(input, "\n"))
        for (jj, char) in enumerate(row)
            mat[ii, jj] = char
        end
    end
    return mat
end

function word_search(mat, patterns)
    finds = 0
    for origin in keys(mat), pattern in patterns
        finds += all(mat[origin .+ diff] == char for (diff, char) in pattern)
    end
    return finds
end


function part_a(input)
    mat = process_input(input)

    dirs = ((0, 1), (1, 1), (-1, 1),
            (0, -1), (1, -1), (-1, -1),
            (1,0), (-1, 0))
    patterns = (((step .* dir, "XMAS"[step + 1]) for step = 0:3) for dir in dirs)

    return word_search(mat, patterns)
end

function part_b(input)
    mat = process_input(input)

    patterns = ((((-1, -1), c1),
                 ((1, -1), c2),
                 ((0, 0), 'A'),
                 ((1, 1), c1 == 'S' ? 'M' : 'S'),
                 ((-1, 1), c2 == 'S' ? 'M' : 'S'))
                for c1 in ('M', 'S'), c2 in ('M', 'S'))

    return word_search(mat, patterns)
end

input = read_day(4)
println(part_a(input))
println(part_b(input))
