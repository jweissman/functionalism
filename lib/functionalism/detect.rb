module Functionalism
  Detect = ->(f) { Compose2[Filter[f],First] }
end
