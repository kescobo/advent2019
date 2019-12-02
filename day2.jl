using Test
using Combinatorics

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

@test processmemory!([1,0,0,0,99]) == [2,0,0,0,99]
@test processmemory!([2,3,0,3,99]) == [2,3,0,6,99]
@test processmemory!([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
@test processmemory!([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]

function startup(infile)
    return parse.(Int, split(readlines(infile)[1], ","))
end

function setmem!(mem, noun, verb)
    mem[2] = noun
    mem[3] = verb
    return mem
end

function solution1(infile)
    mem = startup(infile)
    setmem!(mem, 12, 2)
    # run
    processmemory!(mem)
    return mem[1]
end

solution1("inputs/input2.txt")


function solution2(infile)
    mem = startup(infile)
    for (noun, verb) in with_replacement_combinations(0:99, 2)
        workingmem = deepcopy(mem)
        setmem!(workingmem, noun, verb)
        processmemory!(workingmem)
        workingmem[1] == 19690720 && return (100 * noun + verb)
    end
    error("Didn't find a noun/verb combo")
end

solution2("inputs/input2.txt")
