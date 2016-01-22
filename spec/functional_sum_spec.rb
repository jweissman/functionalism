require 'spec_helper'

describe FunctionalSum2 do
  it 'should sum the result of two functions' do
    expect(FunctionalSum2[Double,Cube].(2)).to eq(12)
  end
end

describe FunctionalSum do
  it 'should sum the result of several functions' do
    property_of {integer}.check do |i|
      expect(FunctionalSum[[Double,Triple,Cube]].(i)).
        to eq(Double[i] + Triple[i] + Cube[i])
    end
  end
end
