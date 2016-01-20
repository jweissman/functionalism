require 'spec_helper'

describe Flatten do
  it 'should flatten arrays together' do
    expect(Flatten.([[1,2],[3],[4,5,6]])).to eq([1,2,3,4,5,6])
    expect(Flatten.([['hello', 'there'],['world']])).to eq(['hello', 'there', 'world'])
  end
end
