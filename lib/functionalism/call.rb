module Functionalism
  Call = lambda do |f,args|
    Proc[f].(*args)
  end.curry
end
