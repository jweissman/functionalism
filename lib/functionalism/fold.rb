module Functionalism
  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  def fold_enumerator(y,f,i,enum)
    return i if enum.size == 0
    val = AsProc[f].(i,First[enum])
    if val != []
      y.yield(*val)
    end
    fold_enumerator(y, f, val, Rest[enum])
  end
  xtail(:fold_enumerator)

  Fold = lambda do |f,initial=nil|
    Proc.new("Fold[#{f.to_s}]") do |collection|
      if collection.size == 0
        initial
      elsif collection.is_a?(Enumerator)
        Enumerator.new do |y|
          Functionalism.fold_enumerator(y, f, First[collection], Rest[collection])
        end
      else
        if initial.nil?
          Functionalism.fold(f,
                             First[collection],
                             Rest[collection])
        else
          Functionalism.fold(f,
                             AsProc[f].(initial,First[collection]),
                             Rest[collection])
        end
      end
    end
  end

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = lambda do |f,initial=nil|
    Proc.new("Foldl[#{f.to_s}]") do |collection|
      if collection.size == 0
        initial
      else
        Foldr[f,initial][Reverse[collection]]
      end
    end
  end

  Unfold = lambda do |f,i|
    Enumerator.new do |y|
      a,b = f.call(i)
      loop do
        y.yield(a)
        a,b = f.call(b)
      end
    end
  end
end
