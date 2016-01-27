module Functionalism
  Max = lambda do |a,b|
    a > b ? a : b
  end

  MaxBy = lambda do |f|
    lambda do |a,b|
      f[a] > f[b] ? a : b
    end
  end

  Min = lambda do |a,b|
    a < b ? a : b
  end

  MinBy = lambda do |f|
    lambda do |a,b|
      f[a] < f[b] ? a : b
    end
  end

  MaximumBy = ->(f,i=nil) { Fold[MaxBy[f], i || -Infinity] }
  MinimumBy = ->(f,i=nil) { Fold[MinBy[f], i || Infinity] }
end
