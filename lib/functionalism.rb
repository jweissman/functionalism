require 'functionalism/version'
require 'functionalism/extend/proc'
require 'functionalism/extend/symbol'

module Functionalism
  def procify(xs)
    xs.map(&:to_proc)
  end

  Identity = ->(x) { x }

  Compose  = lambda do |*xs|
    ps = procify xs
    if ps.empty?
      Identity
    else
      ps.inject(&:compose)
    end
  end

  Apply = lambda do |method, *xs|
    lambda do |*ys|
      procify(xs).send(method) { |p| p[*ys] }
    end
  end

  Splat = ->(*xs) { Apply[:map,  *xs] }

  All   = ->(*xs) { Apply[:all?, *xs] }
  Any   = ->(*xs) { Apply[:any?, *xs] }
  None  = ->(*xs) { -Any[*xs] }

  Filter = lambda do |*xs| 
    ->(arr) { arr.select(&All[*procify(xs)]) }
  end
end
