module Functionalism
  Cycle = lambda do |arr|
    Enumerator.new do |y|
      loop do
        arr.each do |e|
          y.yield(e)
        end
      end
    end
  end
end
