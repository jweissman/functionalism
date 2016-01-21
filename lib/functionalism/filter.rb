module Functionalism
  Filter = lambda do |f|
    Proc.new("Filter[#{f.to_s}]") do |arr|
      reducer = lambda do |acc,x|
        case AsProc[f][x]
        when true then Cons[acc,x]
        when false then acc
        end
      end

      arr = arr.to_a if arr.is_a?(Range)
      Reverse[Fold[reducer][[]][arr]]
    end
  end
  Select = Filter
end
