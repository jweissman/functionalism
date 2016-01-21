require 'spec_helper'

describe Map do
  it 'should apply a function across a list' do
    expect(Map[Succ].([1,2,3])).to eq([2,3,4])
    expect(Map[:*.(2)].([1,2,3])).to eq([2,4,6])
  end
end
