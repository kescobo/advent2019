using Test

struct WirePath{T}
    n::Int
end

function WirePath(instruction::AbstractString)
    m = match(r"^([UDLR])(\d+)$", instruction)
    m == nothing && error("Invalid instruction: $instruction")

    (ord, n) = m.captures
    return WirePath{Symbol(ord)}(parse(Int, n))
end

move(source, wp::WirePath) = error("Invalid Path")

move(source::CartesianIndex, wp::WirePath{:U}) = source + CartesianIndex(0,wp.n)
move(source::CartesianIndex, wp::WirePath{:D}) = source - CartesianIndex(0,wp.n)
move(source::CartesianIndex, wp::WirePath{:R}) = source + CartesianIndex(wp.n,0)
move(source::CartesianIndex, wp::WirePath{:L}) = source - CartesianIndex(wp.n,0)

function straightpath(source, dest)
    return union(
        CartesianIndices(
            range.(Tuple(source), Tuple(dest))),
        CartesianIndices(
            range.(Tuple(dest), Tuple(source))),
        )
end

function wirepath(paths)
    points = Set{CartesianIndex}([])
    source = CartesianIndex(0,0)
    for p in WirePath.(paths)
        dest = move(source, p)
        newpoints = straightpath(source, dest)
        points = union(points, newpoints)
        source = dest
    end
    pop!(points, CartesianIndex(0,0))
    return points
end


function crosswires(w1, w2)
    crosses = intersect(wirepath(w1), wirepath(w2)) |> collect
    return minimum(map(c-> sum(abs(i) for i in Tuple(c)), crosses))
end


@test crosswires(["R8","U5","L5","D3"], ["U7","R6","D4","L4"]) == 6

@test crosswires(["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
                 ["U62","R66","U55","R34","D71","R55","D58","R83"]) == 159
@test crosswires(["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
                 ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]) == 135

function solution1(infile)
    (w1,w2) = map(l-> split(l, ","), eachline(infile))
    crosswires(String.(w1), String.(w1))
end
solution1("inputs/input3.txt")
