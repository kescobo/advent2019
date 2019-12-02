function fuelcost(mass)
    return floor(mass/3) - 2
end

function solution1(infile)
    cost = 0
    for line in eachline(infile)
        mass = parse(Float64, line)
        cost += fuelcost(mass)
    end
    return cost
end
