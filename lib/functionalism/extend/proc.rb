class Proc
  include Functionalism

  def each
    Map[self]
  end

  def map(arr)
    each.(arr)
  end
  alias_method :%, :map

  def memoize
    ->(*args) do
      @results ||= {}
      @results[args] ||= self[*args]
    end
  end
  alias_method :~, :memoize

  def compose(other_fn)
    Compose2[self, other_fn]
  end
  alias_method :|, :compose

  def functional_power(n)
    FunctionalPower[self].(n)
  end
  alias_method :^, :functional_power

  def sum(g)
    FunctionalSum2[self,g]
  end
  alias_method :+, :sum

  def product(g)
    FunctionalProduct2[self,g]
  end
  alias_method :*, :product

  def exponentiate(n)
    Exponentiate[self].(n)
  end
  alias_method :**, :exponentiate

  def negate
    Negate[self]
  end
  alias_method :-@, :negate

  def filter(arr)
    Filter[self].(arr)
  end
  alias_method :&, :filter
  alias_method :select, :filter

  def detect(arr)
    Detect[self].(arr)
  end
  alias_method :find, :detect

  def foldr(collection, initial: nil)
    Fold[self, initial].(collection)
  end
  alias_method :<<, :foldr
  alias_method :fold, :foldr
  alias_method :inject, :foldr
  alias_method :reduce, :foldr

  def foldl(collection, initial: nil)
    Foldl[self, initial].(collection)
  end
  alias_method :>>, :foldl

  def iterate(n)
    Iterate[self].(n)
  end

  def fixed_point(n)
    FixedPoint[self,n]
  end
end
