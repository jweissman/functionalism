require 'spec_helper'

describe Pairwise do
  it 'produces pairs of each element in sequence with its predecessor' do
    expect(Pairwise[ [1,2,3,4] ]).to eq([ [2,1], [3,2], [4,3] ])
  end

  it 'should work with infinite lists' do
    expect(Take[3, Pairwise[Iterate[:**.(2), 2]]]).
      to eq([ [4,2], [16,4], [256, 16] ])
  end
end
