module Functionalism
  Compose2 = lambda do |fn,other_fn|
    Proc.new("Compose2[#{other_fn.to_s}, #{fn.to_s}]") do |*args|
      AsProc[other_fn].(AsProc[fn].(*args))
    end
  end

  Compose = lambda do |fs|
    Proc.new("Compose[#{fs.map(&:to_s).join(', ')}]") do |*args|
      Fold[Compose2][fs].(*args)
    end
  end

  Pipe = Compose
end
