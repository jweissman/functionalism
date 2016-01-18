require 'binding_of_caller'

require 'functionalism/version'

require 'functionalism/procify'

require 'functionalism/identity'
require 'functionalism/compose'
require 'functionalism/send_each'
require 'functionalism/splat'

require 'functionalism/any'
require 'functionalism/all'
require 'functionalism/none'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

module Functionalism
  Filter = lambda do |*fs|
    lambda do |arr|
      return [] if arr.empty?
      x,xs = First[arr], Rest[arr]
      if All[*procify(fs)].(x)
        Cons[Filter[*procify(fs)].(xs), x]
      else
        Filter[*procify(fs)].(xs)
      end
    end
  end
  Select = Filter

  Flip = lambda do |f|
    lambda do |a,b|
      f.(b,a)
    end
  end

  Cons = lambda do |list,element|
    [ element ] + list
  end
  Prepend = Cons

  Append = lambda do |list,element|
    list + [ element ]
  end

  ConsWith = lambda do |f,list,element|
    Cons[ list, f.to_proc.(element) ]
  end.curry

  Iterate = lambda do |fn,i|
    Enumerator.new do |y|
      val = i
      loop do
        y.yield(val)
        val = fn.(val)
      end
    end
  end.curry

  First = lambda do |collection|
    collection[0]
  end

  Rest = lambda do |collection|
    collection[1..-1]
  end

  Reverse = lambda do |collection|
    collection.reverse
  end

  Fold = lambda do |f,i,collection|
    return i if collection.empty?
    x, xs = First[collection], Rest[collection]
    Fold[f, f.to_proc.(i, x), xs]
  end.curry

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f,i,Reverse[collection]] }.curry

  Map  = ->(f) { Foldl[ConsWith[f]].([]) }
  Mapr = ->(f) {  Fold[ConsWith[f]].([]) }

  Negate = lambda do |f|
    ->(*args) { !f[*args] }
  end

  Sum = lambda do |*fs|
    lambda do |*args|
      Fold[:+][0].(Splat[*procify(fs)].(*args))
    end
  end

  Product = lambda do |*fs|
    lambda do |*args|
      Fold[:*][1].(Splat[*procify(fs)].(*args))
    end
  end

  Recurse = lambda do |operation|
    lambda do |fn|
      lambda do |n|
        case n
        when 0 then Identity
        when 1 then fn
        else
          operation[fn, Recurse[operation][fn][n-1]]
        end
      end
    end
  end

  Exponentiate = Recurse[Product]
  FunctionalPower = Recurse[Compose2]
end
