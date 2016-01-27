module Functionalism
  Take = lambda do |n, a|
    return [] if n == 0
    # p [:take, n, a ]
    fst = First[a]
    Flip[Prepend][
      fst,
      Take[n-1, Drop[1,a]]
    ]
  end

  TakeWhile = lambda do |p, a|
    return [] if !AsProc[p][First[a]]
    Cons[TakeWhile[p, Rest[a]], First[a]]
  end

  Drop = lambda do |n, a|
    return a if n == 0
    Drop[n-1, Rest[a]]
  end

  DropWhile = lambda do |p|
    lambda do |arr| #(a,*as)|
      a,as = First[arr], Rest[arr]
      if !AsProc[p][a]
        Cons[as,a]
      else
        DropWhile[p][as]
      end
    end
  end

  # DropUntil = lambda do |p|
  #   DropWhile[Negate[p]]
  # end
end
