module Functionalism
  Filter = lambda do |f,arr|
    reducer = lambda do |acc,x|
      case f.to_proc[x]
      when true then Cons[acc,x]
      when false then acc
      end
    end

    arr = arr.to_a if arr.is_a?(Range)
    Reverse[Fold[reducer,[],arr]]
  end.curry
  Select = Filter
end
