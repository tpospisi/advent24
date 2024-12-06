include("common.jl")

function process_input(input)
    rows = [parse.(Int, split(line)) for line in split(input, "\n")]
    return rows
end

function passes(row, tolerance=0)
    rowdiff = diff(row)
    main_sign = sign(sum(sign.(rowdiff)))

    errors = 0
    for (idx, el) in enumerate(rowdiff)
        if (abs(el) > 3) || (el == 0) || (sign(el) != main_sign)
            errors += 1
            if errors > tolerance
                return false
            end
            if idx != length(rowdiff)
                rowdiff[idx + 1] += el
            end
        end
    end
    return true
end

function part_a(input)
    rows = process_input(input)
    return sum(passes(row) for row in rows)
end

function part_b(input)
    rows = process_input(input)
    return sum(passes(row, 1) || passes(reverse(row), 1) for row in rows)
end

input = read_day(2)
println(part_a(input))
println(part_b(input))
