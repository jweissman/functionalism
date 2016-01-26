module Functionalism
  ReplicatorFor = lambda do |a|
    Fold[ConsWith[Constant[a]],[]]
  end

  Replicate = lambda do |n,a|
    n == 0 ? [] : ReplicatorFor[a].(0..n)
  end
end
