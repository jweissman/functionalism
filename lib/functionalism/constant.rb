module Functionalism
  Constant = ->(x) { ->(*) { x } }

  Zero = Constant[0]
  One  = Constant[1]
  Two  = Constant[2]
  Ten  = Constant[10]
end
