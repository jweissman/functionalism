require 'spec_helper'

describe 'Reverse' do
  it 'should invert the order of a collection' do
    expect(Reverse.([1,2,3])).to eq([3,2,1])
  end

  describe "Compose2[Reverse,Reverse]" do
    it 'should be id for lists' do
      property_of { array( (rand*100).to_i ) { integer }}.check do |as|
        expect(Compose2[Reverse,Reverse].(as)).to eq(as)
      end
    end
  end
end
