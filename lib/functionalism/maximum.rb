module Functionalism
  Max = lambda do |a,b|
    a > b ? a : b
  end

  Min = lambda do |a,b|
    a < b ? a : b
  end

  Maximum = lambda do |(a,*as)|
    return a if as.empty?
    Max[a, Maximum[as]]
  end

  Minimum = lambda do |(a,*as)|
    return a if as.empty?
    Min[a, Minimum[as]]
  end
end
