include("common.jl")
using DataStructures
using Combinatorics

struct Block
    id::Int
    num::Int
end

id(block) = block.id
num(block) = block.num

is_file(block) = id(block) != -1
is_free(block) = id(block) == -1
is_empty(block) = num(block) == 0

function process_input(input)
    id, free = 0, false
    mem = Block[]
    for num in parse.(Int, collect(input))
        push!(mem, Block(free ? -1 : id, num))
        id += !free
        free = !free
    end
    return mem
end

function compact!(filesystem::Vector{Block}, complete_only)
    front_el = 2
    back_el = length(filesystem)

    while front_el < back_el
        back_block = filesystem[back_el]
        if is_free(back_block) || is_empty(back_block)
            back_el -= 1
            continue
        end
        if is_file(filesystem[front_el]) || is_empty(filesystem[front_el])
            front_el += 1
        end
        
        moved = false
        for iter_el in front_el:back_el
            iter_block = filesystem[iter_el]
            (is_file(iter_block) || is_empty(iter_block)) && continue
            to_move = min(num(back_block), num(iter_block))
            (complete_only && to_move != num(back_block)) && continue
            filesystem[iter_el] = Block(id(iter_block), num(iter_block) - to_move)
            filesystem[back_el] = Block(id(back_block), num(back_block) - to_move)
            insert!(filesystem, back_el, Block(id(iter_block), to_move))
            insert!(filesystem, iter_el, Block(id(back_block), to_move))
            back_el += 2
            moved = true
            break
        end
        if !moved
            back_el -= 1
        end
    end
    return filesystem
end

function checksum(filesystem::Vector{Block})
    tot, pos = 0, 0
    for block in filesystem
        if is_file(block)
            tot += id(block) * sum(pos:(pos+num(block)-1))
        end
        pos += num(block)
    end
    return tot
end

        
function part_a(input)
    filesystem = process_input(input)
    return checksum(compact!(filesystem, false))
end

function part_b(input)
    filesystem = process_input(input)
    return checksum(compact!(filesystem, true))
end

input = read_day(9)
println(part_a(input))
@time println(part_b(input))
