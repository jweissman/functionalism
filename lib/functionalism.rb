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

  Filter = lambda do |*xs|
    ->(arr) { arr.select(&All[*procify(xs)]) }
  end
end
