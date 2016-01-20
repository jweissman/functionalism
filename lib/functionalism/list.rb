module Functionalism
  List = lambda do |a,*as|
    return a if as.empty?
    Cons[List[as],a]
  end
end
