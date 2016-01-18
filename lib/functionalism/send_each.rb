module Functionalism
  ApplyEach = lambda do |g, *fs|
    ->(*ys) { g.(fs) { |f| f[*ys] } }
  end

  SendEach = lambda do |method, *fs|
    ApplyEach[method.to_proc, *procify(fs)]
  end
end
