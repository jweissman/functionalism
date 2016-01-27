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
require 'functionalism/detect'
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
require 'functionalism/exponentiate'
require 'functionalism/functional_power'
require 'functionalism/quicksort'
require 'functionalism/split_at'
require 'functionalism/pairwise'
require 'functionalism/tap'

require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

require 'functionalism/fixed_point'

module Functionalism
  AsProc = lambda do |f, name=nil|
    Proc.new("AsProc[#{name || f.to_s}]") do |*args|
      f.to_proc.(*args)
    end
  end

  Procify = Map[AsProc]

  Halve = :*.(0.5)
  Double = :*.(2)
  Triple = :*.(3)
  Quadruple = :*.(4)

  Square = :**.(2)
  Cube   = :**.(3)

  Infinity = 1.0/0
  # InfiniteSet = Iterate [Constant[value]]
  # hmmm, this is basically Iterate[Constant[value]]
  # class InfiniteSet < Struct.new(:value)
  #   def size
  #     Infinity
  #   end

  #   def first
  #     value
  #   end

  #   def rest
  #     InfiniteSet.new
  #   end
  # end
end
