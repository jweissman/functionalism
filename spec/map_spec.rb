require 'spec_helper'

describe Map do
  it 'should apply a function across a list' do
    expect(Map[Succ].([1,2,3])).to eq([2,3,4])
    expect(Map[:*.(2)].([1,2,3])).to eq([2,4,6])
  end

  it 'should distribute over function composition' do
    property_of { array(10) { integer } }.check do |i|
      expect(  Compose2[Map[Double], Map[Square]].(i) ).
        to eq( Map[Compose2[Double,Square]].(i))
    end
  end
end
