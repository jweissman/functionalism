module Functionalism
  Tap = lambda do |f|
    lambda do |args|
      AsProc[f].(args)
      args
    end
  end
  Tee = Tap
end
