require 'spec_helper'

describe Flatten do
  it 'should flatten arrays together' do
    expect(Flatten.([[1,2],[3],[4,5,6]])).to eq([1,2,3,4,5,6])
    expect(Flatten.([['hello', 'there'],['world']])).to eq(['hello', 'there', 'world'])

    expect(Flatten.([[[1],nil,nil],[nil],[nil,nil]])).to eq([[1],nil,nil,nil,nil,nil])
  end

  it 'should have a synonym (Join) for joining strings togethers' do
    expect(Join.(%w[ a b c d ])).to eq('abcd')
  end
end
