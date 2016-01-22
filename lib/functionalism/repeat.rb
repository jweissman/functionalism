module Functionalism
  Repeat = lambda do |e|
    Enumerator.new do |y|
      loop { y.yield(e) }
    end
  end
end
