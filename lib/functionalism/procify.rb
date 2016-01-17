module Functionalism
  def procify(xs)
    xs.map(&:to_proc)
  end
end
