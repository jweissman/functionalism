module Functionalism
  Compose2 = lambda do |fn,other_fn|
    lambda do |*args|
      other_fn.to_proc.(fn.to_proc[*args])
    end
  end

  Compose = ->(*xs) { Fold[Compose2][Identity].(procify(xs)) }
end
