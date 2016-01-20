module Functionalism
  First = lambda do |collection|
    collection.first
  end
  Head = First

  Rest = lambda do |collection|
    if collection.is_a?(Enumerator)
      collection.lazy.drop(1)
    elsif collection.is_a?(Range)
      ((collection.begin+1)...collection.end)
    else
      collection[1..-1]
    end
  end
  Tail = Rest
end
