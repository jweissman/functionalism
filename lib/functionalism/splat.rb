module Functionalism
  Splat = ->(*fs) { SendEach[:map, *fs] }

  SplatHash = lambda do |hash|
    lambda do |*args|
      hash.inject({}) do |hsh,(key,f)|
        hsh[key] = f[*args]; hsh
      end
    end
  end
end
