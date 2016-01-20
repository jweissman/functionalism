module Functionalism
  Cons = lambda do |list,element|
    list = [ list ] unless list.is_a?(Array)
    [ element ] + list
  end
  Prepend = Cons

  Append = lambda do |list,element|
    list + [ element ]
  end
end
