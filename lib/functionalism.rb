require 'functionalism/version'

module Functionalism
  Identity = ->(x) { x }

  Compose  = ->(*xs) do
    ps = xs.map(&:to_proc)

    if ps.empty?
      Identity
    else
      ps.inject(&:compose)
    end
  end

  Splat = ->(*xs) do
    ps = xs.map(&:to_proc)
    ->(*ys) { ps.map { |p| p[*ys] } }
  end

  All = ->(*xs) do
    ps = xs.map(&:to_proc)
    ->(*ys) { ps.all? { |p| p[*ys] }}
  end

  Any = ->(*xs) do
    ps = xs.map(&:to_proc)
    ->(*ys) { ps.any? { |p| p[*ys] }}
  end
end

class Proc
  def compose(other_fn)
    other_fn = other_fn.to_proc if other_fn.is_a?(Symbol)
    ->(*args) { other_fn[self[*args]] }
  end
  alias_method :|, :compose

  def functional_power(n)
    case n
    when 0 then identity
    when 1 then self
    else
      compose functional_power(n-1)
    end
  end
  alias_method :^, :functional_power

  def sum(g)
    ->(*args) { self[*args] + g[*args] }
  end
  alias_method :+, :sum

  def product(g)
    ->(*args) { self[*args] * g[*args] }
  end
  alias_method :*, :product

  def exponentiate(n)
    case n
    when 0 then identity
    when 1 then self
    else
      product exponentiate(n-1)
    end
  end
  alias_method :**, :exponentiate

  def memoize
    ->(*args) do
      @results ||= {}
      @results[args] ||= self[*args]
    end
  end
  alias_method :~, :memoize

  def apply_to_all(arr)
    arr.map(&self)
  end
  alias_method :%, :apply_to_all

  protected
  def identity
    ->(x) { x }
  end
end
