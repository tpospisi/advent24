include("common.jl")

function process_input(input)
    rules_str, seqs_str = split(input, "\n\n")
    rules = Set([Tuple(parse.(Int, split(el, "|"))) for el in eachsplit(rules_str, "\n")])
    rows = [parse.(Int, split(el, ",")) for el in eachsplit(seqs_str, "\n")]
    return rules, rows
end

midpoint(xx) = xx[div(length(xx) + 1, 2)]

function part_a(input)
    rules, rows = process_input(input)
    lt = (x, y) -> (x, y) in rules
    return sum(issorted(row, lt = lt) ? midpoint(row) : 0 for row in rows)
end

function part_b(input)
    rules, rows = process_input(input)
    lt = (x, y) -> (x, y) in rules
    return sum(issorted(row, lt = lt) ? 0 : midpoint(sort(row, lt = lt)) for row in rows)
end

input = read_day(5)
println(part_a(input))
println(part_b(input))
