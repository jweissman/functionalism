module Functionalism
  Flip = ->(f,x,y) { AsProc[f].(y,x) }.curry
end
