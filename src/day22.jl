include("common.jl")
using Base.Iterators
using IterTools
using Chain
using DataStructures

mix(val, secret) = xor(val, secret)
prune(secret) = secret % 16777216
last_digit(n) = n % 10
function next(state)
    @chain state begin
        mix(_ * 64, _)
        prune
        mix(div(_, 32), _)
        prune
        mix(_ * 2048, _)
        prune
    end
end

struct SecretSeq
    start::Int
    price::Bool
end
SecretSeq(val::Int) = SecretSeq(val, false)

Base.iterate(it::SecretSeq) = (it.price ? last_digit(it.start) : it.start, next(it.start))
function Base.iterate(it::SecretSeq, state)
    return it.price ? last_digit(state) : state, next(state)
end
Base.IteratorSize(::Type{<:SecretSeq}) = Base.SizeUnknown()
Base.eltype(::Type{<:SecretSeq}) = Int

function sell_prices(start)
    prices = DefaultDict{NTuple{4, Int}, Int}(0)
    for subseq in IterTools.partition(take(SecretSeq(start, true), 2001), 5, 1)
        d = subseq[2:end] .- subseq[1:(end-1)]
        val = subseq[end]
        if !haskey(prices, d) # only take the first occurance
            prices[d] = val
        end
    end
    return prices
end

function process_input(input)
    return parse.(Int, split(input, "\n"))
end

function part_a(input)
    starts = process_input(input)
    return sum(nth(SecretSeq(x), 2001) for x in starts)
end

function part_b(input)
    starts = process_input(input)
    price_dicts = map(sell_prices, starts)
    total_price = merge(+, price_dicts...)
    return maximum(values(total_price))
end

input = read_day(22)
println(part_a(input))
println(part_b(input))
