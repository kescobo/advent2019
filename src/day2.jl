using Test

function getinstruction(mem, address)
    return mem[address .+ [0,1,2,3]]
end

function processcode(mem, address)
    (oppcode, i1, i2, a2) = getinstruction(mem, address)
    oppcode == 99 && return nothing
    if oppcode == 1
        opp = +
    elseif oppcode == 2
        opp = *
    else
        error("Weird code at address = $address: $([oppcode, param1, param2, a2])")
    end
    return (opp, mem[i1+1], mem[i2+1], a2)
end

function processmemory!(mem)
    i = 1
    while mem[i] != 99
        (opp, param1, param2, a2) = processcode(mem, i)
        mem[a2+1] = opp(param1, param2)
        i += 4
    end
    return mem
end

function startup(infile)
    return parse.(Int, split(readlines(infile)[1], ","))
end

function setmem!(mem, noun, verb)
    mem[2] = noun
    mem[3] = verb
    return mem
end

function solution2(infile)
    for (noun, verb) in Iterators.product(0:99, 0:99)
        mem = startup(infile)
        setmem!(mem, noun, verb)
        processmemory!(mem)
        mem[1] == 19690720 && return (100 * noun + verb)
    end
    error("Didn't find a noun/verb combo")
end

@test solution2("inputs/input2.txt") == 6421
