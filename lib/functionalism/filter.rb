module Functionalism
  Filter = lambda do |f|
    pr = Proc.new do |arr|
      reducer = lambda do |acc,x|
        case AsProc[f][x] #f.to_proc[x]
        when true then Cons[acc,x]
        when false then acc
        end
      end

      arr = arr.to_a if arr.is_a?(Range)
      Reverse[Fold[reducer][[],arr]]
    end
    pr.name = "Filter[#{f.to_s}]"
    pr
  end
  Select = Filter
end
