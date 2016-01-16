module Functionalism
  Compose  = lambda do |*xs|
    if xs.empty?
      Identity
    else
      procify(xs).inject(&:compose)
    end
  end
end
