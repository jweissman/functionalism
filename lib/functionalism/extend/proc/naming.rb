class Proc
  attr_reader :name

  def initialize(name=nil,&blk)
    @name = name
    super(&blk)
  end

  def inspect
    to_s
  end

  def to_s
    identify.empty? ? super : identify
  end

  protected
  def identify
    @name ||= Functionalism.constants(false).detect do |const|
      Functionalism.const_get(const) == self
    end.to_s
  end
end
