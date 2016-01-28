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
  All = ->(p) { Compose2[Map[p],And] }
  Any = ->(p) { Compose2[Map[p], Or] }

  # Divide2 = :/
  # Modulo2 = :%
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
end
