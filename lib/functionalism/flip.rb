module Functionalism
  Flip = ->(f,x,y) { Proc[f].(y,x) }.curry
end
