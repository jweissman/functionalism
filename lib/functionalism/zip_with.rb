module Functionalism
  ZipEnumeratorWith = lambda do |f, arr_a, arr_b|
    Enumerator.new do |y|
      n = 0
      loop do
        pair = f.( First[Drop[n,arr_b]], First[Drop[n,arr_a]] )
        y.yield( pair )
        n = n + 1
      end
    end
  end

  ZipWith = lambda do |f|
    Proc.new("ZipWith[#{f.to_s}]") do |arr_a, arr_b|
      if arr_a.is_a?(Enumerator) || arr_b.is_a?(Enumerator)
        ZipEnumeratorWith[f,arr_a,arr_b]
      else
        a,*as = *arr_a
        b,*bs = *arr_b

        if bs.empty? || as.empty?
          [f.(b,a)]
        else
          # TODO fold
          Cons[ ZipWith[f][as,bs],  f.(b,a) ]
        end
      end
    end
  end.curry

  Zip = ZipWith[Cons]

  UnzipWith = lambda do |f|
    Proc.new("UnzipWith[#{f.to_s}]") do |arrs|
      fa = f.(*Map[First].(arrs))
      rests = (Map[Rest].(arrs))
      if rests.any? { |rest| rest.empty? }
        [fa]
      else
        Cons[ UnzipWith[f][rests], fa ]
      end
    end
  end

  Unzip = UnzipWith[List]
end
