require 'binding_of_caller'

require 'functionalism/version'

require 'functionalism/identity'
require 'functionalism/compose'
require 'functionalism/send_each'
require 'functionalism/splat'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

module Functionalism
  def procify(xs)
    xs.map(&:to_proc)
  end

  All   = ->(*xs) { SendEach[:all?, *xs] }
  Both = All

  Any   = ->(*xs) { SendEach[:any?, *xs] }
  Some  = Any

  None  = ->(*xs) { -Any[*xs] }
  Neither = None

  Filter = lambda do |*fs|
    ->(arr) { arr.select(&All[*procify(fs)]) }
  end

  Cons = lambda do |*as,b|
    (as << b).flatten(1)
  end

  # apply fn and prepend
  ConsWith = lambda do |f|
    lambda do |*as,b|
      (as << f.to_proc[b]).flatten(1)
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

  Fold = lambda do |f|
    lambda do |initial_value|
      lambda do |collection|
        accumulator = initial_value
        collection.each do |element|
          accumulator = f.to_proc.(accumulator, element)
        end
        accumulator
      end
    end
  end

  Map = ->(f) { Fold[ConsWith[f]].([]) }


  Negate = lambda do |f|
    ->(*args) { !f[*args] }
  end

  # still not the best name here...
  ApplyAndFold = lambda do |reducer, initial=0|
    lambda do |*fs|
      lambda do |*args|
        Fold[reducer][initial].(Splat[*procify(fs)].(*args))
      end
    end
  end

  Sum = ApplyAndFold[:+]
  Product = ApplyAndFold[:*, 1]

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
  FunctionalPower = Recurse[Compose]
end
