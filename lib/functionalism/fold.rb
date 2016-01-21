module Functionalism
  # extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  Fold = lambda do |f|
    Proc.new("Fold[#{f.to_s}]") do |i|
      proc do |collection|
        if collection.size == 0
          i 
        else
          Functionalism.fold(f, AsProc[f].(i,First[collection]), Rest[collection])
        end
      end
    end
  end

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f][i][Reverse[collection]] }.curry
end
