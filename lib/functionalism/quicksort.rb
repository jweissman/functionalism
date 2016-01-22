module Functionalism
  Quicksort = lambda do |(x,*xs)|
    return [] if x.nil?
    Quicksort[Filter[:<=.(x)][xs]] + [ x ] + Quicksort[Filter[:>.(x)][xs]]
  end
  QSort = Quicksort
end
