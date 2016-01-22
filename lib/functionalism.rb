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
require 'functionalism/quicksort'
require 'functionalism/split_at'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

module Functionalism
  # this has got to be expressible as a fold right?
  Recurse = lambda do |operation, fn, n|
    case n
    when 0 then Identity
    when 1 then fn
    else
      operation[fn, Recurse[operation, fn, n-1]]
    end
  end.curry

  Exponentiate = Recurse[FunctionalProduct2]
  FunctionalPower = Recurse[Compose2]

  AsProc = lambda do |f, name=nil|
    Proc.new("AsProc[#{name || f.to_s}]") do |*args|
      f.to_proc.(*args)
    end
  end

  Procify = Map[AsProc]

  # Detect = Compose2[Filter,First] # fixme? :)
  Double = :*.(2)
  Triple = :*.(3)
  Square = :**.(2)
  Cube   = :**.(3)
end
