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
