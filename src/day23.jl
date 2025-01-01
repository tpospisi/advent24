include("common.jl")
using Graphs
using MetaGraphsNext
using Chain

function process_input(input)
    g = MetaGraph(SimpleGraph(), String)
    for line in split(input, "\n")
        left, right = split(line, "-")
        add_vertex!(g, left)
        add_vertex!(g, right)
        add_edge!(g, right, left)
    end
    return g
end

function part_a(input)
    g = process_input(input)
    @chain g begin
        simplecycles_limited_length(_, 3)
        filter(x -> length(x) == 3, _)
        map(sort, _)
        unique
        map(x -> Base.Fix1(label_for, g).(x), _)
        return count(x -> any(startswith("t"), x), _)
    end
end

function part_b(input)
    g = process_input(input)
    @chain g begin
        maximal_cliques
        argmax(length, _)
        map(x -> label_for(g, x), _)
        sort
        return join(_, ",")
    end
end

input = read_day(23)
println(part_a(input))
println(part_b(input))
