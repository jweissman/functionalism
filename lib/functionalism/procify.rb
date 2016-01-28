module Functionalism
  AsProc = lambda do |f, name=nil|
    Proc.new("AsProc[#{name || f.to_s}]") do |*args|
      f.to_proc.(*args)
    end
  end

  Procify = Map[AsProc]
end
