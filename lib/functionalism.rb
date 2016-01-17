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
  Void = ->(*) { raise 'Void is uncallable' }
  def void?(*xs)
    xs == [ Void ]
    # xs.size == 1 && xs.first == Void
  end

 Identity = lambda do |x=nil| #->(x=nil) do
   # p [:id, x]
   if x.nil?
     Void
   else
     x
   end
 end


  Filter = lambda do |*fs|
    ->(arr) { arr.select(&All[*procify(fs)]) }
  end

  Cons = lambda do |list,element|
    # p [:cons, list, element ]
    list = [ list ] unless list.is_a?(Array)
    [ element ] + list #.flatten(1)
    # (as << b).flatten(1)
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
        return initial_value if collection.empty?
        first = collection.shift
        first_value = f.to_proc[initial_value, first]
        Fold[f][first_value][collection]
      end
    end
  end

  Foldl = lambda do |f|
    lambda do |initial_value|
      lambda do |collection|
        return initial_value if collection.empty?
        first = collection.pop
        first_value = f.to_proc[initial_value, first]
        Foldl[f][first_value][collection]
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
  FunctionalPower = Recurse[Compose2]
end
