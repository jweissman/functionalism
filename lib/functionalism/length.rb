module Functionalism
  Length = ->(collection) {
    if collection.is_a?(InfiniteSet)
      Infinity
    else
      Fold[Successor, 0].(collection)
    end
  }
end
