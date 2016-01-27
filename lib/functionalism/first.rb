module Functionalism
  First = lambda do |collection|
    collection = collection.chars if collection.is_a?(String)
    collection.first
  end
  Head = First

  Rest = lambda do |collection|
    collection = collection.chars if collection.is_a?(String)
    if collection.is_a?(Enumerator)
      collection.lazy.drop(1)
    elsif collection.is_a?(Range)
      ((collection.begin+1)...collection.end)
    elsif collection.is_a?(InfiniteSet)
      InfiniteSet.new
    else
      collection[1..-1]
    end
  end
  Tail = Rest
end
