module Functionalism
  Map  = lambda do |f|
    Proc.new("Map[#{f.to_s}]") do |*args|
      Foldl[ConsWith[f]].([]).(*args)
    end
  end

  Mapr = lambda do |f|
    Proc.new("Mapr[#{f.to_s}]") do |*args|
      Fold[ConsWith[f]].([]).(*args)
    end
  end
end
