require 'spec_helper'

describe Maximum do
  it 'finds the largest of a set' do
    expect(Maximum[[1,2,3]]).to eq(3)
    expect(Maximum[[8,12,14,16]]).to eq(16)
  end

  it 'has an antonym (Minimum)' do
    expect(Minimum[[1,2,3]]).to eq(1)
    expect(Minimum[[8,12,14,16]]).to eq(8)
  end
end
