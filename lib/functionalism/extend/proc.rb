class Proc
  # def each
  #   method(:map).to_proc
  # end

  def memoize
    ->(*args) do
      @results ||= {}
      @results[args] ||= self[*args]
    end
  end
  alias_method :~, :memoize

  def compose(other_fn)
    Compose[self, other_fn]
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

  def map(arr)
    Map[self].(arr)
  end
  alias_method :%, :map

  def filter(arr)
    Filter[self].(arr)
  end
  alias_method :&, :filter

  def fold(collection, initial: 0)
    Fold[self][initial].(collection)
  end
  alias_method :<<, :fold

  def iterate(n)
    Iterate[self].(n)
  end
end
