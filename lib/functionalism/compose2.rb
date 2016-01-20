module Functionalism
  Compose2 = lambda do |fn,other_fn|
    lambda do |*args|
      Proc[other_fn].(Proc[fn].(*args))
    end
  end

  Compose = Fold[Compose2][Identity]
  Pipe = Compose
end
