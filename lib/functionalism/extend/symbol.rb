class Symbol
  extend Forwardable
  include Functionalism

  def_delegators :to_proc, :|, :-@ #, :each

  def each
    Map[self]
  end

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
    Proc.new("#{self.to_s}#{args}") do |caller|
      result = nil

      quietly do
        result = caller.send(self, *args, &block)
      end

      result
    end
  end

  protected
  def quietly(&blk)
    old_verbosity = $VERBOSE
    $VERBOSE = nil
    yield
    $VERBOSE = old_verbosity
  end
end
