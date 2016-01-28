require 'spec_helper'

describe Count do
  it 'should indicate the number of elements in a collection matching a predicate' do
    expect(Count[:even?].([1,2,3,4,5])).to eq(2)
  end
end
