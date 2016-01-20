module Functionalism
  ConsWith = lambda do |f,list,*element|
    Cons[ list, Call[f,element]]
  end.curry
end
