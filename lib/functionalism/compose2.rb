module Functionalism
  Compose2 = lambda do |fn,other_fn|
    pr = Proc.new do |*args|
      AsProc[other_fn].(AsProc[fn].(*args))
    end
    pr.name = "Compose2[#{other_fn.to_s}, #{fn.to_s}]"
    pr
  end

  Compose = lambda do |fs|
    pr = Proc.new do |*args|
      Fold[Compose2][Identity][fs].(*args)
    end
    pr.name = "Compose[#{fs.map(&:to_s).join(', ')}]"
    pr
  end

  Pipe = Compose
end
