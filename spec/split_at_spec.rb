require 'spec_helper'

describe SplitAt do
  it 'should split an array at the given index' do
    expect(SplitAt[3].([1,2,3,4,5])).to eq([[1,2,3],[4,5]])
    expect(SplitAt[0].([1,2,3])).to eq([[],[1,2,3]])
  end
end
