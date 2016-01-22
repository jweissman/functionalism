require 'spec_helper'

describe 'Initial' do
  it 'should return all but the last element of a collection' do
    expect(Initial.([1,2,3])).to eq([1,2])
    expect(Initial.([1,2])).to eq([1])
    expect(Initial.([1,2,3,5,8,11])).to eq([1,2,3,5,8])
    expect(Initial[%w[ hello my baby ]]).to eq(%w[ hello my ])
  end

  it 'should have an antonym (Last)' do
    expect(Last.([2,4,8])).to eq(8)
    expect(Last.([1,2])).to eq(2)
    expect(Last.([1,2,3,5,8,11])).to eq(11)
    expect(Last[%w[ hello my baby ]]).to eq('baby')
  end
end
