using Test

function validpw(n::Int)
    dig = digits(n) |> reverse
    length(dig) == 6 || return false
    all(i-> dig[i] <= dig[i+1], 1:5) || return false
    any(i-> dig[i] == dig[i+1], 1:5) || return false
end

@test validpw(111111)
@test !validpw(223450)
@test !validpw(123789)

solution1(low, high) = sum(validpw, low:high)

solution1(109165,576723)

function validgroups(dig)
    for i in 1:5
        if dig[i] == dig[i+1]
            if i == 5
                dig[i] != dig[i-1] && return true
            elseif i == 1
                dig[i] != dig[i+2] && return true
            else
                dig[i] != dig[i+2] && dig[i] != dig[i-1] && return true
            end
        end
    end
    return false
end

function validpw2(n::Int)
    dig = digits(n) |> reverse
    length(dig) == 6 || return false
    all(i-> dig[i] <= dig[i+1], 1:5) || return false
    return validgroups(dig)
end


@test validpw2(112233)
@test !validpw2(123444)
@test validpw2(111122)

solution2(low, high) = sum(validpw2, low:high)

solution2(109165,576723)


function tests()
    @testset "tests" begin
        @testset "valid" begin
            @test  validpw2(112233)
            @test  validpw2(112345)
            @test  validpw2(112335)
            @test  validpw2(123445)
            @test  validpw2(123455)
            @test  validpw2(123355)
            @test  validpw2(111122)
            @test  validpw2(113444)
        end
        @testset "invalid" begin
            @test !validpw2(123444)
            @test !validpw2(123334)
            @test !validpw2(223450)
            @test !validpw2(987654)
        end
    end
end

tests()
