require 'functionalism/version'

class Proc
  def compose(other_fn)
    ->(*as) { other_fn.call(self.call(*as)) }
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
    ->(*as) { call(*as) + g.call(*as) }
  end
  alias_method :+, :sum

  def product(g)
    ->(*as) { call(*as) * g.call(*as) }
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
    ->(*as) do
      @results ||= {}
      @results[as] ||= call(*as) 
    end
  end

  protected
  def identity
    ->(x) { x }
  end

  def constant(value)
    ->(*) { value }
  end
end
