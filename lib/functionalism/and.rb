module Functionalism
  And2     = ->(a,b) { a && b }
  And      = Fold[And2, true]
end
