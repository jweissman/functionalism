module Functionalism
  Not = lambda do |f|
    ->(*args) { !f[*args] }
  end
  Negate = Not
end
