module Functionalism
  FunctionalSum2 = lambda do |f,g|
    Proc.new("FunctionalSum2[#{f.to_s}, #{g.to_s}]") do |*args|
      Sum2.( f[*args] ).( g[*args] )
    end
  end

  FunctionalSum = Fold[FunctionalSum2]
end
