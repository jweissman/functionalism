require 'binding_of_caller'

require 'functionalism/version'

require 'functionalism/support/tco'

require 'functionalism/extend/proc/naming'

require 'functionalism/logging'

require 'functionalism/identity'
require 'functionalism/first'
require 'functionalism/successor'

require 'functionalism/iterate'
require 'functionalism/fold'
require 'functionalism/flatten'
require 'functionalism/filter'
require 'functionalism/call'
require 'functionalism/compose'
require 'functionalism/length'
require 'functionalism/second'
require 'functionalism/flip'
require 'functionalism/cons'
require 'functionalism/cons_with'
require 'functionalism/reverse'
require 'functionalism/initial'
require 'functionalism/list'
require 'functionalism/map'
require 'functionalism/zip_with'
require 'functionalism/maximum'
require 'functionalism/replicate'
require 'functionalism/take'
require 'functionalism/cycle'
require 'functionalism/repeat'
require 'functionalism/negate'
require 'functionalism/and'
require 'functionalism/or'
require 'functionalism/sum'
require 'functionalism/product'
require 'functionalism/constant'
require 'functionalism/functional_sum'
require 'functionalism/functional_product'
require 'functionalism/exponentiate'
require 'functionalism/functional_power'
require 'functionalism/quicksort'
require 'functionalism/split_at'
require 'functionalism/pairwise'
require 'functionalism/tap'
require 'functionalism/orbit'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

require 'functionalism/procify'
require 'functionalism/detect'
require 'functionalism/fixed_point'

module Functionalism
  All = ->(p) { Compose2[Map[p], And] }
  Any = ->(p) { Compose2[Map[p], Or] }

  None = Compose2[Not, Any]

  Count = ->(p) { Compose2[Filter[p], Length] }

  Index = ->(arr,p,n=0) {
    if Length[arr]==0
      nil
    elsif AsProc[p][First[arr]]
      n
    else
      Index[Rest[arr],p,n+1]
    end
  }

  ElementIndex = ->(arr,i) { Index[arr,->(x){ i==x }] }

  RightIndex = ->(arr,p) {
    if Length[arr] == 0
      nil
    elsif AsProc[p][Last[arr]]
      Length[arr]-1
    else
      RightIndex[Initial[arr],p]
    end
  }

  # RightmostElementIndex = ->(arr,i) { RightmostIndex[arr,->(x){i==x}] }

  Modulo2 = ->(a,b) { a % b }

  # Divide2 = :/
  # Equals = ->(a,b) { a == b }
  # IsZero = ->(x) { Equals[0,x] }
  # IsEven = Modulo2|IsZero
  # IsOdd = Not[IsEven]

  Halve = :*.(0.5)
  Double = :*.(2)
  Triple = :*.(3)
  # Quadruple = :*.(4)

  Square = :**.(2)
  Cube   = :**.(3)

  Infinity = 1.0/0

  IsTruthy = ->(x) { !!x }

  IsA = lambda do |klass, obj|
    obj.is_a?(klass)
  end.curry

  IsSymbol = IsA[Symbol]
  IsClass = IsA[Class]

  DescendsFrom = lambda do |possible_parent, klass|
    IsClass[klass] && klass.ancestors.include?(possible_parent)
  end.curry

  Wrap = ->(f,x=nil) { Proc.new("Wrap[#{f.to_s}]") { f.(x) } }

  Print = ->(s) { print s }
  Puts = ->(s) { Print[s+"\n"] }
  Gets = ->(*){ gets }
  Chomp = ->(s) { s.chomp }

  Forever = ->(f,x=nil) { f.(x) while true }

  Inner = Compose2[Initial,Rest]
end
