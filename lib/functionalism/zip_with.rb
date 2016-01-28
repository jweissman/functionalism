module Functionalism
  ZipOnce = lambda do |(arr_a, arr_b)|
    [[ First[arr_a], First[arr_b] ],
     [ Rest[arr_a],  Rest[arr_b] ]]
  end

  Zip = lambda do |arr_a, arr_b|
    if arr_a.is_a?(Enumerator) || arr_b.is_a?(Enumerator)
      Unfold[ ZipOnce, [arr_a, arr_b] ]
    else
      UnfoldStrict[ ZipOnce, [arr_a, arr_b] ]
    end
  end

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
