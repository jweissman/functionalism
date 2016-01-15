class Symbol
  extend Forwardable
  def_delegators :to_proc, :|

  def each
    return to_proc.method(:apply_to_all).to_proc
  end

  def call(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end

  def element
    ->(*as) { send(self, *as) }
  end

  def elements
    lambda do |args|
      args.each do |arg|
        send(self, arg)
      end
    end
  end
end
