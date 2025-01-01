include("common.jl")

function process_input(input)
    locks = Tuple{Int, Int, Int, Int, Int}[]
    keys = Tuple{Int, Int, Int, Int, Int}[]
    for block in split(input, "\n\n")
        mat = matfromchar(block)
        sig = Tuple(sum(mat .== '#', dims = 1))
        lock = all(mat[1,:] .== '#')
        push!(lock ? locks : keys, sig)
    end
    return locks, keys
end

function part_a(input)
    locks, keys = process_input(input)
    return sum(all(lock .+ key .<= 7) for lock in locks, key in keys)
end

input = read_day(25)
println(part_a(input))
