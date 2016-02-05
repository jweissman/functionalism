module Functionalism
  Take = lambda do |n, a|
    return [] if n == 0 || a.nil?
    Flip[Prepend][
      First[a],
      Take[n-1, Drop[1,a]]
    ]
  end

  TakeWhile = lambda do |p, a|
    return [] if a.nil? || First[a].nil? || !AsProc[p][First[a]]
    Cons[TakeWhile[p, Rest[a]], First[a]]
  end

  Drop = lambda do |n, a|
    return a if n == 0
    Drop[n-1, Rest[a]]
  end

  DropWhile = lambda do |p,arr|
    a,as = First[arr], Rest[arr]
    return [] if a.nil?
    if !AsProc[p][a]
      Cons[as,a]
    else
      DropWhile[p][as]
    end
  end.curry
end
