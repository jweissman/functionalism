require 'spec_helper'

describe 'Length' do
  it 'measures the size of a collection' do
    property_of { array( (rand * 100).to_i ) { integer } }.check do |as|
      expect(Length[as]).to eq(as.size)
    end
  end
end
