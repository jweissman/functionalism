module Functionalism
  Exp = ->(fn) do
    Proc.new("Exp[#{fn.to_s}]") do |n|
      if n == 0
        Identity
      else
        Fold[FunctionalProduct2,One].(Replicate[n,fn])
      end
    end
  end
  Exponentiate = Exp
end
