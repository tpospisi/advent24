include("common.jl")

using Graphs
using MetaGraphsNext
using NetworkLayout
using GLMakie
using GraphMakie

function process_input(input)
    start_vals, ops_list = split(input, "\n\n")

    vals = Dict{String, Bool}()

    g = MetaGraph(SimpleDiGraph(), String, Tuple{Bool, Bool}, String)
    for line in split(ops_list, "\n")
        re = r"(.*) (XOR|OR|AND) (.*) -> (.*)"
        m = match(re, line)
        left, op, right, out = m.captures

        if left > right
            left, right = right, left
        end
        
        leftright = "$left$op$right"
        
        g[left] = (false, false)
        g[right] = (false, false)
        g[leftright] = (false, false)
        g[out] = (false, false)

        g[left, leftright] = op
        g[right, leftright] = op
        g[leftright, out] = "ID"
    end

    for line in split(start_vals, "\n")
        wire, val = split(line, ": ")
        g[wire] = (true, val == "1")
    end

    return g
end

function str2fn(op_str)
    Dict("XOR" => (x, y) -> (x[1] && y[1], xor(x[2], y[2])),
         "AND" => (x, y) -> (x[1] && y[1], x[2] && y[2]),
         "OR" => (x, y) -> (x[1] && y[1], x[2] || y[2]))[op_str]
end

function search_value(g, label)
    parents = collect(inneighbor_labels(g, label))
    if length(parents) == 1
        g[label] = search_value(g, parents[1])
    elseif length(parents) == 2
        op = str2fn(g[parents[1], label])
        g[label] = op(search_value(g, parents[1]), search_value(g, parents[2]))
    end
    return g[label]
end

function part_a(input)
    g = process_input(input)
    z_labels = filter(startswith("z"), collect(labels(g)))
    foreach(label -> search_value(g, label), z_labels)
    return sum(2 ^ (ii - 1) * g[label][2] for (ii, label) in enumerate(sort(z_labels)))
end

function part_b(input)
    g = process_input(input)
    # f, ax, p = graphplot(g,  layout=Stress(), nlabels=collect(labels(g)))
    # visually look at the graph to see which adder is messed up
    swaps = ("ggrXORhnd", "x12ANDy12",
             "stjXORttg", "vhmORwwd",
             "x29XORy29", "x29ANDy29",
             "cmcANDgkw", "cmcXORgkw") # 16
    wires = [collect(outneighbor_labels(g, x))[1] for x in swaps]
    return join(sort(wires), ",")
end

input = read_day(24)
println(part_a(input))
println(part_b(input))
