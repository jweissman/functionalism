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
  Exp = ->(fn) do
    Proc.new("Exp[#{fn.to_s}]") do |n|
      if n == 0
        Identity
      else
        Fold[FunctionalProduct2,One].(Replicate[n,fn])
      end
    end
  end
  Exponentiate = Exp

  FunctionalPower = ->(fn) do
    Proc.new("FunctionalPower[#{fn.to_s}]") do |n|
      if n == 0
        Identity
      else
        Fold[Compose2,Identity].(Replicate[n,fn])
      end
    end
  end

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
