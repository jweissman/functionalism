module Functionalism
  extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  module_function(:fold)
  xtail :fold

  def fold_enumerator(y,f,i,enum)
    return i if enum.size == 0
    val = AsProc[f].(i,First[enum])
    if val != []
      y.yield(*val)
    end
    fold_enumerator(y, f, val, Rest[enum])
  end
  module_function(:fold_enumerator)
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

  UnfoldLazy = lambda do |f,i|
    Enumerator.new do |y|
      a,b = f.call(i)
      loop do
        y.yield(a)
        a,b = f.call(b)
      end
    end
  end.curry

  IsNull = ->(x) { x.nil? }
  HasNulls = ->(a) { a.is_a?(Array) && Any[IsNull][a] }

  IsNullOrHasNulls = ->(a) { IsNull[a] || HasNulls[a] }

  UnfoldStrict = lambda do |f,i|
    TakeWhile[
      Not[IsNullOrHasNulls],
      UnfoldLazy[f, i]
    ]
  end.curry

  Unfold = UnfoldLazy
end
