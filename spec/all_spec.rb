require 'spec_helper'

describe All do
  it 'should return true when a predicate applies to every element in a collection' do
    expect( All[:even?].([2,3,4]) ).to eq(false)
    expect( All[:even?].([2,4,6]) ).to eq(true)
  end
end
