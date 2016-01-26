module Functionalism
  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  def fold_enumerator(f,i,arr,y)
    return i if arr.size == 0
    y.yield(AsProc[f].(i,First[arr]))
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end

  Fold = lambda do |f,i=nil|
    Proc.new("Fold[#{f.to_s}]") do |collection|
      initial = i || likely_zero_element_for(collection)
      if collection.size == 0
        initial
      elsif collection.is_a?(Enumerator)
        # enumerate fold...
        Enumerator.new do |y|
          loop do
            Functionalism.fold_enumerator(f, AsProc[f].(initial,First[collection]), Rest[collection], y)
          end
        end
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

  protected
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
