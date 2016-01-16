module Functionalism
  SendEach = lambda do |method, *fs|
    lambda do |*ys|
      procify(fs).send(method) do |p|
        p[*ys]
      end
    end
  end
end
