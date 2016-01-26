module Functionalism
  FunctionalPower = ->(fn) do
    Proc.new("FunctionalPower[#{fn.to_s}]") do |n|
      if n == 0
        Identity
      else
        Fold[Compose2,Identity].(Replicate[n,fn])
      end
    end
  end
end
