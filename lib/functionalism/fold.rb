module Functionalism
  # extend TailCallOptimization

  def fold(f,i,arr)
    return i if arr.size == 0
    fold(f, AsProc[f].(i,First[arr]), Rest[arr])
  end
  xtail :fold
  module_function(:fold)

  Fold = lambda do |f,i|
    Proc.new("Fold[#{f.to_s}]") do |collection|
      if collection.size == 0
        i 
      else
        Functionalism.fold(f, AsProc[f].(i,First[collection]), Rest[collection])
      end
    end
  end

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f,i][Reverse[collection]] }.curry

  # def likely_zero_element_for(c)
  #   i = c.first
  #   case i
  #   when Hash then {}
  #   when Array then []
  #   when String then ""
  #   when Numeric then 0
  #   # when Proc then Identity # <--- could we use this to simplify fold impl or calls (or even display)...?
  #   end
  # end
end
