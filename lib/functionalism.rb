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
    ->(arr) { arr.select(&All[*procify(fs)]) }
  end
  Select = Filter

  Cons = lambda do |list,element|
    list = [ list ] unless list.is_a?(Array)
    [ element ] + list
  end
  Cell = Cons

  # apply fn and prepend
  ConsWith = lambda do |f|
    # what do i need for this to work: Compose2[ f.to_proc, Cons ]
    lambda do |list,element|
      Cons[ list, f.to_proc.(element) ]
    end
  end


  Iterate = lambda do |fn|
    lambda do |initial_value|
      Enumerator.new do |y|
        val = initial_value
        loop do
          y.yield(val)
          val = fn.(val)
        end
      end
    end
  end

  First = lambda do |collection|
    collection[0]
  end

  Rest = lambda do |collection|
    collection[1..-1]
  end

  Reverse = lambda do |collection|
    collection.reverse
  end

  Fold = lambda do |f|
    lambda do |i|
      lambda do |collection|
        return i if collection.empty?
        x, xs = First[collection], Rest[collection]
        Fold[f][ f.to_proc.(i, x) ][xs]
      end
    end
  end
  Foldr  = Fold
  Inject = Fold
  Reduce = Fold

  Foldl = lambda do |f|
    lambda do |i|
      lambda do |collection|
        return i if collection.empty?
        x, xs = First[Reverse[collection]], Reverse[Rest[Reverse[collection]]]
        Foldl[f][ f.to_proc.(i, x) ][xs]
      end
    end
  end

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
