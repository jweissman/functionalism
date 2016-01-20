module Functionalism
  Iterate = lambda do |fn,i|
    Enumerator.new do |y|
      val = i
      loop do
        y.yield(val)
        val = fn.(val)
      end
    end
  end.curry
end
