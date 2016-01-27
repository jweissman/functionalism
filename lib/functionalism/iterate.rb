module Functionalism
  Enumerate = lambda do |fn, i|
    Enumerator.new do |y|
      val = i
      loop do
        y.yield(val)
        val = fn.call(val)
      end
    end
  end

  Iterate = ->(fn,i) { Enumerate[Call[fn], i] }.curry
end
