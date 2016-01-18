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

  Filter = lambda do |f,arr|
    reducer = lambda do |acc,x|
      case f.to_proc[x]
      when true then Cons[acc,x]
      when false then acc
      end
    end

    arr = arr.to_a if arr.is_a?(Range)
    Reverse[Fold[reducer,[],arr]]
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

  List = lambda do |*args|
    return [] if args.empty?
    Cons[ List[*Rest[args]], First[args]]
  end

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
    if collection.is_a?(Enumerator)
      collection.lazy.drop(1)
    else
      collection[1..-1]
    end
  end

  def fold(f,i,arr)
    return i if arr.empty?
    fold(f, f.to_proc.(i,First[arr]), Rest[arr])
  end
  xtail :fold

  Fold = lambda do |f,i,collection|
    fold(f,i,collection)
  end.curry

  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = ->(f,i,collection) { Foldr[f,i,Reverse[collection]] }.curry

  Reverse = Fold[Prepend,[]]
  Last = Compose2[Reverse, First]


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

  UnzipWith = lambda do |f,arrs|
    fa = f.(*Map[First].(arrs))
    rests = (Map[Rest].(arrs))

    return [fa] if rests.any? { |rest| rest.empty? }

    Cons[ UnzipWith[f][rests], fa ]
  end.curry

  Unzip = UnzipWith[List]

  Max = lambda do |a,b|
    a > b ? a : b
  end

  Min = lambda do |a,b|
    a < b ? a : b
  end

  Maximum = lambda do |arr|
    return arr.first if arr.size == 1
    Max[First[arr], Maximum[Rest[arr]]]
  end

  Minimum = lambda do |arr|
    return arr.first if arr.size == 1
    Min[First[arr], Minimum[Rest[arr]]]
  end

  Replicate = lambda do |n, a|
    return [] if n == 0
    Cons[Replicate[n-1][a], a]
  end.curry

  Take = lambda do |n, a|
    return [] if n == 0
    Cons[Take[n-1, Rest[a]], First[a]]
  end

  TakeWhile = lambda do |p, a|
    return [] if !p.to_proc[First[a]]
    Cons[TakeWhile[p, Rest[a]], First[a]]
  end

  Drop = lambda do |n, a|
    return a if n == 0
    Drop[n-1, Rest[a]]
  end

  DropWhile = lambda do |p,a|
    return a if !p.to_proc[First[a]]
    DropWhile[p, Rest[a]]
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

  Successor = lambda do |n|
    if n.is_a?(Numeric)
      n + 1
    elsif n.is_a?(String)
      n.next
    end
  end
  Succ = Successor

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
