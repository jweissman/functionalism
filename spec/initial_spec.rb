require 'spec_helper'

describe 'Initial' do
  it 'should return all but the last element of a collection' do
    expect(Initial.([1,2,3])).to eq([1,2])
  end

  it 'should have an antonym (Last)' do
    expect(Last.([2,4,8])).to eq(8)
  end
end
