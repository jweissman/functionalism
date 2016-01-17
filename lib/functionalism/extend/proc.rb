class Proc
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
    Sum[self, g]
  end
  alias_method :+, :sum

  def product(g)
    Product[self, g]
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

  def foldr(collection, initial: likely_zero_element_for(collection))
    Fold[self][initial].(collection)
  end
  alias_method :<<, :foldr
  alias_method :fold, :foldr

  def foldl(collection, initial: likely_zero_element_for(collection))
    Foldl[self][initial].(collection)
  end
  alias_method :>>, :foldl

  def iterate(n)
    Iterate[self].(n)
  end

  def likely_zero_element_for(c)
    i = c.first
    case i
    when Hash then {}
    when Array then []
    when String then ""
    when Numeric then 0
    end
  end
end
