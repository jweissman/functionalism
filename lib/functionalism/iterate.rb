module Functionalism
  Iterate = ->(f,i) { Unfold[->(x) { [x, f.(x)] }, i]}.curry
end
