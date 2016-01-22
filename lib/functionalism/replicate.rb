module Functionalism
  Replicate = lambda do |n, a|
    return [] if n == 0
    Cons[Replicate[n-1][a], a]
  end.curry
end
