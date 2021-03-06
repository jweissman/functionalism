require 'spec_helper'

describe Any do
  it 'should return true when a predicate applies to every element in a collection' do
    expect( Any[:even?].([2,3,4]) ).to eq(true)
    expect( Any[:even?].([2,4,6]) ).to eq(true)
    expect( Any[:even?].([3,5,7]) ).to eq(false)
  end

  it 'should have an antonym (None)' do
    expect( None[:even?].([2,3,4]) ).to eq(false)
    expect( None[:even?].([1,3,5]) ).to eq(true)
  end
end
