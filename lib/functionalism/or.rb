module Functionalism
  Or2      = ->(a,b) { a || b }
  Or       = Fold[Or2, false]
end
