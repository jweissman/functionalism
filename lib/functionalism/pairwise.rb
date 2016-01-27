module Functionalism
  # each element and its pred as pair
  Pairwise = lambda do |arr|
    Zip[Drop[1,arr], arr]
  end

  PairMatches = ->((a,b)) { a == b }
end
