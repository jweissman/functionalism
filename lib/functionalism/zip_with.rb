module Functionalism
  ZipWith = lambda do |f|
    Proc.new("ZipWith[#{f.to_s}]") do |(a,*as), (b,*bs)|
      if bs.empty? || as.empty?
        [f.(b,a)]
      else
        Cons[ ZipWith[f][as,bs],  f.(b,a) ]
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
