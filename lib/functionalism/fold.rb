module Functionalism
  extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, f.to_proc.(i,First[arr]), Rest[arr])
  end
  xtail :fold

  Fold = lambda do |f,i,collection|
    Functionalism.fold(f,i,collection)
  end.curry

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f,i,Reverse[collection]] }.curry
end
