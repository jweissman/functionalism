require 'binding_of_caller'

require 'functionalism/version'

require 'functionalism/support/tco'

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
  extend TailCallOptimization

  def filter(f,arr)
    arr = arr.to_a if arr.is_a?(Range)
    pr = f.to_proc
    x,xs = arr.first, arr[1..-1]

    if arr.empty?
      []
    elsif pr.(x)
      [ x ] + filter(f,xs)
    else
      filter(f,xs)
    end
  end
  xtail :filter

  Filter = lambda do |f,arr|
    filter(f, arr)
  end.curry

  Select = Filter

  Flip = lambda do |f|
    lambda do |a,b|
      f.(b,a)
    end
  end

  Cons = lambda do |list,element|
    list = [ list ] unless list.is_a?(Array)
    [ element ] + list
  end
  Prepend = Cons

  Append = lambda do |list,element|
    list + [ element ]
  end

  ConsWith = lambda do |f,list,*element|
    Cons[ list, f.to_proc.(*element) ]
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
    collection.first
  end

  Rest = lambda do |collection|
    collection[1..-1]
  end

  Reverse = lambda do |collection|
    return [] if collection.empty?
    Append[Reverse[Rest[collection]], First[collection]]
  end

  Last = Compose2[Reverse, First]

  def fold(f,i,arr)
    return i if arr.empty?
    x,xs = First[arr], Rest[arr]
    fold(f, f.to_proc.(i,x), xs)
  end
  xtail :fold

  Fold = lambda do |f,i,collection|
    fold(f,i,collection)
  end.curry

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f,i,Reverse[collection]] }.curry

  Map  = ->(f) { Foldl[ConsWith[f]].([]) }
  Mapr = ->(f) {  Fold[ConsWith[f]].([]) }

  ZipWith = lambda do |f,arr_a,arr_b|
    a,as = First[arr_a], Rest[arr_a]
    b,bs = First[arr_b], Rest[arr_b]
    fab = f[b,a]
    return [fab] if bs.empty? || as.empty?
    Cons[ ZipWith[f][as,bs],  fab ]
  end.curry

  Zip = ZipWith[Cons]

  Negate = lambda do |f|
    ->(*args) { !f[*args] }
  end

  Sum     = Fold[:+, 0]
  Product = Fold[:*, 1]

  FunctionalSum = lambda do |*fs|
    lambda do |*args|
      Sum.(Splat[*procify(fs)].(*args))
    end
  end

  FunctionalProduct = lambda do |*fs|
    lambda do |*args|
      Product.(Splat[*procify(fs)].(*args))
    end
  end

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
end
