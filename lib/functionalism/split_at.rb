module Functionalism
  # TODO fold?
  SplitAt = lambda do |n, arr|
    return [[],arr] if n == 0
    return [[],[]] if arr.empty?
    raise "Can't split on negative index!" unless n > 0
    x, xs = First[arr], Rest[arr]
    xs_prime, xs_prime_prime = *SplitAt[n-1,xs]
    [ Cons[xs_prime, x], xs_prime_prime ]
  end.curry
end
