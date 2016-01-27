module Functionalism
  Enumerate = lambda do |fn, i|
    Enumerator.new do |y|
      n = 0
      val = i
      loop do
        # p [:iterate, n ]
        y.yield(val)
        val = fn.call(val)
        n = n + 1
      end
    end
  end

  Iterate = ->(fn,i) { Enumerate[Call[fn], i] }.curry
end
