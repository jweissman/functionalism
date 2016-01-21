module Functionalism
  Call = lambda do |f,args|
    AsProc[f].(*args)
  end.curry
end
