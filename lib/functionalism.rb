require 'binding_of_caller'

require 'functionalism/version'

require 'functionalism/support/tco'

require 'functionalism/extend/proc/naming'

require 'functionalism/identity'
require 'functionalism/iterate'
require 'functionalism/first'
require 'functionalism/fold'
require 'functionalism/flatten'
require 'functionalism/filter'
require 'functionalism/call'
require 'functionalism/compose'
require 'functionalism/successor'
require 'functionalism/length'
require 'functionalism/second'
require 'functionalism/flip'
require 'functionalism/splat'
require 'functionalism/cons'
require 'functionalism/cons_with'
require 'functionalism/reverse'
require 'functionalism/initial'
require 'functionalism/list'
require 'functionalism/map'
require 'functionalism/zip_with'
require 'functionalism/maximum'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

module Functionalism
  Replicate = lambda do |n, a|
    return [] if n == 0
    Cons[Replicate[n-1][a], a]
  end.curry

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

  Cycle = lambda do |arr|
    Enumerator.new do |y|
      loop do
        arr.each do |e|
          y.yield(e)
        end
      end
    end
  end

  Repeat = lambda do |e|
    Enumerator.new do |y|
      loop { y.yield(e) }
    end
  end

  Negate = lambda do |f|
    ->(*args) { !f[*args] }
  end

  Sum     = Fold[:+, 0]
  Product = Fold[:*, 1]

  And     = Fold[->(a,b) { a && b }, true]
  Or      = Fold[->(a,b) { a || b }, false]

  FunctionalSum = lambda do |*fs|
    lambda do |*args|
      Sum[Splat[fs,args]]
    end
  end

  FunctionalProduct = lambda do |*fs|
    lambda do |*args|
      Product[Splat[fs,args]]
    end
  end

  # this has got to be expressible as a fold right?
  Recurse = lambda do |operation, fn, n|
    case n
    when 0 then Identity
    when 1 then fn
    else
      operation[fn, Recurse[operation, fn, n-1]]
    end
  end.curry

  Exponentiate = Recurse[FunctionalProduct]
  FunctionalPower = Recurse[Compose2]

  Quicksort = lambda do |(x,*xs)|
    return [] if x.nil?
    Quicksort[Filter[:<=.(x)][xs]] + [ x ] + Quicksort[Filter[:>.(x)][xs]]
  end
  QSort = Quicksort

  SplitAt = lambda do |n, arr|
    return [[],arr] if n == 0
    return [[],[]] if arr.empty?
    raise "Can't split on negative index!" unless n > 0
    x, xs = First[arr], Rest[arr]
    xs_prime, xs_prime_prime = *SplitAt[n-1,xs]
    [ Cons[xs_prime, x], xs_prime_prime ]
  end.curry

  AsProc = lambda do |f, name=nil|
    Proc.new("AsProc[#{name || f.to_s}]") do |*args|
      f.to_proc.(*args)
    end
  end

  Procify = Map[AsProc]

  # Detect = Compose2[Filter,First] # fixme? :)
end
