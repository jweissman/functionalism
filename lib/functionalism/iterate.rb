module Functionalism
  Enumerate = lambda do |fn, i|
    Enumerator.new do |y|
      val = i
      loop do
        # p [:iterate, fn, val]
        y.yield(val)
        val = fn.call(val)
      end
    end
  end

  Iterate = ->(fn,i) { Enumerate[Call[fn], i] }.curry
end
