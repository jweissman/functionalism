module Functionalism
  Succ = ->(n, *_) { n + 1 }
  Successor = Succ

  Pred = ->(n, *_) { n - 1 }
  Predecessor = Pred
end
