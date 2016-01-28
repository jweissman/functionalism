module Functionalism
  Repeat2 = ->(x) {[x,x]}
  Repeat = ->(i) { Unfold[Repeat2,i] }
end
