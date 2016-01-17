module Functionalism
  Compose = lambda do |*xs|
    if xs.empty?
      Identity
    else
      procify(xs).reduce do |fn, other_fn|
        lambda do |*args|
          other_fn.(fn.(*args))
        end
      end
    end
  end
end
