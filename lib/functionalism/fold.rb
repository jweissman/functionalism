module Functionalism
  # extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  Fold = lambda do |f,i=nil|
    Proc.new("Fold[#{f.to_s}]") do |collection|
      initial = i || likely_zero_element_for(collection)
      if collection.size == 0
        initial
      else
        Functionalism.fold(f, AsProc[f].(initial,First[collection]), Rest[collection])
      end
    end
  end

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = lambda do |f,i=nil|
    Proc.new("Foldl[#{f.to_s}]") do |collection|
      initial = i || likely_zero_element_for(collection)
      if collection.size == 0
        initial
      else
        Foldr[f,initial][Reverse[collection]]
      end
    end
  end

  private
  def likely_zero_element_for(c)
    i = c.first
    case i
    when Hash then {}
    when Array then []
    when String then ""
    when Numeric then 0
    when Proc, Symbol then Identity
    end
  end
end
