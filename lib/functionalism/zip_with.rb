module Functionalism
  ZipOnce = lambda do |(arr_a, arr_b)|
    [[ First[arr_a], First[arr_b] ],
     [ Rest[arr_a],  Rest[arr_b] ]]
  end

  Zip = lambda do |arr_a, arr_b|
    if arr_a.is_a?(Enumerator) || arr_b.is_a?(Enumerator)
      Unfold[ ZipOnce, [arr_a, arr_b] ]
    else
      arr_a = arr_a.to_a if arr_a.is_a?(Range)
      arr_b = arr_b.to_a if arr_b.is_a?(Range)

      UnfoldStrict[ ZipOnce, [arr_a, arr_b] ]
    end
  end

  PairifyProc = ->(f) { ->((a,b)) { AsProc[f].(a,b) }}
  ZipWith = lambda do |f,arr_a,arr_b|
    Map[PairifyProc[f]][Zip[arr_a, arr_b]]
  end.curry

  UnzipOnce = lambda do |arrs|
    [ Map[First].(arrs), (Map[Rest].(arrs)) ]
  end

  Unzip = lambda do |arrs|
    if arrs.any? { |arr| arr.is_a?(Enumerator) }
      Unfold[UnzipOnce, arrs]
    else
      UnfoldStrict[UnzipOnce, arrs]
    end
  end
end
