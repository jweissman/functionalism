class Symbol
  extend Forwardable
  def_delegators :to_proc, :|, :-@, :each

  def as_method
    AsProc[binding.of_caller(1).eval "method(:#{self})", self.to_s + ".as_method"]
  end

  def as_method_of(klass)
    AsProc[klass.method(self), self.to_s]
  end

  def elements
    Mapr[as_method]
  end

  # for currying procs
  def call(*args, &block)
    lambda do |caller, *rest| 
      caller.send(self, *rest, *args, &block)
    end
  end
end
