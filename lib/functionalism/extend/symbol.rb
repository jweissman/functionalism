class Symbol
  extend Forwardable
  def_delegators :to_proc, :|, :-@, :each
  
  def as_method
    binding.of_caller(1).eval "method(:#{self}).to_proc"
  end

  def as_method_of(klass)
    klass.method(self).to_proc
  end

  def elements
    Mapr[as_method]
  end

  def call(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end
end
