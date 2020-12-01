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

move(source, wp::WirePath{:U}) = source .+ (0,wp.n)
move(source, wp::WirePath{:D}) = source .- (0,wp.n)
move(source, wp::WirePath{:R}) = source .+ (wp.n,0)
move(source, wp::WirePath{:L}) = source .- (wp.n,0)

function straightpath(source, dest)
    if source[2] == dest[2]
        source[1] < dest[1] ? xs = range(source[1], stop=dest[1]) : xs = range(source[1], step=-1, stop=dest[1])
        ys = fill(source[2], length(xs))
    elseif source[1] == dest[1]
        source[2] < dest[2] ? ys = range(source[2], stop=dest[2]) : ys = range(source[2], step=-1, stop=dest[2])
        xs = fill(source[1], length(ys))
    else
        @error "No straight path available" source, dest
    end

    return zip(xs[2:end],ys[2:end])
end

function wirepath(paths)
    points = [(0,0)]
    for p in WirePath.(paths)
        source = points[end]
        dest = move(source, p)
        append!(points, straightpath(source, dest))
    end
    return points[2:end]
end


function crosswires(w1, w2)
    crosses = intersect(wirepath(w1), wirepath(w2)) |> collect
    return minimum(map(c-> sum(abs(i) for i in c), crosses))
end


@test crosswires(["R8","U5","L5","D3"], ["U7","R6","D4","L4"]) == 6

@test crosswires(["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
                 ["U62","R66","U55","R34","D71","R55","D58","R83"]) == 159
@test crosswires(["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
                 ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]) == 135

function solution1(infile)
    wires = map(l-> split(l, ","), eachline(infile))
    crosswires(wires[1], wires[2])
end

solution1("inputs/input3.txt")

function crosspaths(w1, w2)
    p1, p2 = (wirepath(w1), wirepath(w2))
    l1, l2 = (length(p1), length(p2))
    crosses = Dict()
    for i in 1:max(l1, l2)
        if i <= l1 && p1[i] in p2
            haskey(crosses, p1[i]) ? crosses[p1[i]]["p1"] = i : crosses[p1[i]] = Dict("p1"=>i)
        end
        if i <= l2 && p2[i] in p1
            haskey(crosses, p2[i]) ? crosses[p2[i]]["p2"] = i : crosses[p2[i]] = Dict("p2"=>i)
        end
    end
    return minimum(sum((crosses[k]["p1"], crosses[k]["p2"])) for k in keys(crosses))
    # return crosses
end

@test crosspaths(["R8","U5","L5","D3"], ["U7","R6","D4","L4"]) == 30

@test crosspaths(["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
                 ["U62","R66","U55","R34","D71","R55","D58","R83"]) == 610
@test crosspaths(["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
                 ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]) == 410

function solution2(infile)
    wires = map(l-> split(l, ","), eachline(infile))
    crosspaths(wires[1], wires[2])
end

solution2("inputs/input3.txt")
