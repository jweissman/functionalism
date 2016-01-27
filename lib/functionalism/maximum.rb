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

  Maximum = Fold[Max]
  Minimum = Fold[Min]

  MaximumBy = ->(f) { Fold[MaxBy[f]] }
  MinimumBy = ->(f) { Fold[MinBy[f]] }
end
