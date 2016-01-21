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
    f = self
    pr = Proc.new do |caller|
      caller.send(f, *args, &block)
    end.curry
    pr.name = "#{f.to_s}#{args}"
    pr
  end
end
