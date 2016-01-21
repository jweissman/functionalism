module Functionalism
  # extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  Fold = lambda do |f|
    pr = Proc.new do |i,collection|
      if collection.size == 0
        i 
      else
        Functionalism.fold(f, AsProc[f].(i,First[collection]), Rest[collection])
      end
    end.curry
    pr.name = "Fold[#{f.to_s}]"
    pr
  end

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f][i,Reverse[collection]] }.curry
end
