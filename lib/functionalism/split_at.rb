module Functionalism
  SplitAt = lambda do |n|
    raise "Can't split on negative index!" unless n >= 0
    lambda do |arr|
      [ Take[n,arr], Drop[n, arr] ]
    end
  end
end
