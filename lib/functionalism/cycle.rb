module Functionalism
  CycleOne = lambda do |arr,x|
    [x, arr[Modulo2[Successor[Index[arr,x]], Length[arr]]]]
  end.curry

  Cycle = lambda do |arr|
    raise "Cycle cannot accept an empty list" if arr.size == 0
    arr = arr.to_a if arr.is_a?(Range)
    Unfold[CycleOne[arr], First[arr]]
  end
end
