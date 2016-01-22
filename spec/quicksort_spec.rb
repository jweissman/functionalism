require 'spec_helper'

describe Quicksort do
  it 'should sort a list' do
    expect(Quicksort.([2,3,1,4])).to eq([1,2,3,4])
    expect(QSort.(['a','c','e','b','d'])).to eq(['a', 'b', 'c', 'd', 'e'])
  end
end
