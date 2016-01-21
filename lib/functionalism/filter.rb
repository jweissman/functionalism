module Functionalism
  FilterOne = lambda do |f|
    Proc.new("FilterOne[#{f.to_s}]") do |acc,x|
      case AsProc[f][x]
      when true then Cons[acc,x]
      when false then acc
      end
    end
  end

  Filter = ->(f) { Foldl[FilterOne[f], []] }
  Select = Filter
end
