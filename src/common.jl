using Printf

function read_day(day::Integer)
    path = joinpath(@__DIR__, "..", "data", @sprintf("day%d.txt", day))
    s = open(path, "r") do file
        read(file, String)
    end
    return chomp(s)
end
