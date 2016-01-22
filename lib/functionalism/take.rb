module Functionalism
  Take = lambda do |n, a|
    return [] if n == 0
    Cons[Take[n-1, Rest[a]], First[a]]
  end

  TakeWhile = lambda do |p, a|
    return [] if !AsProc[p][First[a]]
    Cons[TakeWhile[p, Rest[a]], First[a]]
  end

  Drop = lambda do |n, a|
    return a if n == 0
    Drop[n-1, Rest[a]]
  end

  DropWhile = lambda do |p,(a,*as)|
    if !AsProc[p][a]
      Cons[as,a]
    else
      DropWhile[p,as]
    end
  end
end
