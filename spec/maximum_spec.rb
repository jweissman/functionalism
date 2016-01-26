require 'spec_helper'

describe 'Maximum' do
  it 'finds the largest of a set' do
    expect(Maximum[[1,2,3]]).to eq(3)
    expect(Maximum[[8,12,14,16]]).to eq(16)
  end

  it 'has an antonym (Minimum)' do
    expect(Minimum[[1,2,3]]).to eq(1)
    expect(Minimum[[8,12,14,16]]).to eq(8)
  end

  describe "MaximumBy" do
    it 'is a higher-order version that takes a measurement function' do
      expect(MaximumBy[Length, ''].(%w[ hi there ]) ).to eq( 'there' )
      expect(MaximumBy[Length,[]].([ [1], [2,3] ]) ).to eq( [2,3] )
      expect(MinimumBy[Length,InfiniteSet.new].([ [1], [2,3] ]) ).to eq( [1] )
    end
  end
end
