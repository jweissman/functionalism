module Functionalism
  FilterOne = lambda do |f|
    Proc.new("FilterOne[#{f.to_s}]") do |acc,x|
      case AsProc[f][x]
      when true then Cons[acc,x]
      when false then acc
      end
    end
  end

  Filter = lambda do |f|
    Proc.new("Filter[#{f.to_s}]") do |collection|
      if collection.is_a?(Enumerator)
        # create a new filtered enumerator *around* the 'inner' enumerator :/
        # can this be written as unfold...?
        Enumerator.new do |y_prime|
          collection.each do |element|
            if AsProc[f][element]
              y_prime.yield(element)
            end
          end
        end
      else
        Compose2[ Reverse, Fold[FilterOne[f], []] ].(collection)
      end
    end
  end
  Select = Filter
end
