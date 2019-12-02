function fuelcost(mass)
    cost = floor(mass/3) - 2
    cost < 0 && (cost = 0.)
    return cost
end

function solution1(infile)
    cost = 0
    for line in eachline(infile)
        mass = parse(Float64, line)
        cost += fuelcost(mass)
    end
    return Int(cost)
end

solution1("inputs/input1.1")


function solution2(infile)
    cost = 0
    for line in eachline(infile)
        mass = parse(Float64, line)
        cost += fuelcost(mass)
    end

    fcost = fuelcost(cost)
    while fcost > 0
        cost += fcost
        fcost = fuelcost(fcost)
    end
    return Int(cost)
end

solution2("inputs/input1.1")
