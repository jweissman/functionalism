module Functionalism
  Splat = lambda do |fs,ys|
    Map[Flip[Call][ys]].(fs)
  end.curry
end
