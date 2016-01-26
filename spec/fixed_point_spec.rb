require 'spec_helper'

describe Pairwise do
  it 'produces pairs of each element in sequence with its predecessor' do
    expect(Pairwise[ [1,2,3,4] ]).to eq([ [2,1], [3,2], [4,3] ])
  end

  it 'should work with infinite lists' do
    expect(Take[3, Pairwise[Iterate[Square,2]]]).
      to eq([ [4,2], [16,4], [256, 16] ])
  end
end

describe FixedPoint do
  let(:polynomial_with_fixed_point) do
    ->(x) { (x**2) - (3*x) + 4 }
  end

  it 'should identify a known fixed point of a polynomial function' do
    expect(FixedPoint[polynomial_with_fixed_point,1]).to eq(2)
    expect(FixedPoint[polynomial_with_fixed_point,2]).to eq(2)

    expect(FixedPoint[Double,0]).to eq(0)
    expect(FixedPoint[Square,1]).to eq(1)
  end
end
