class Proc
  def compose(other_fn)
    ->(*args) { other_fn.to_proc[self[*args]] }
  end
  alias_method :|, :compose

  def functional_power(n)
    case n
    when 0 then Identity
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
    when 0 then Identity
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

  def negate
    ->(*args) { !self[*args] }
  end
  alias_method :-@, :negate
end
