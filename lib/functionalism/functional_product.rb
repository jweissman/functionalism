module Functionalism
  FunctionalProduct2 = lambda do |f,g|
    Proc.new("FunctionalProduct2[#{f.to_s}, #{g.to_s}]") do |*args|
      Product2.( f.(*args) ).( g.(*args) )
    end
  end

  FunctionalProduct = Fold[FunctionalProduct2]
end
