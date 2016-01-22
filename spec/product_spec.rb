require 'spec_helper'

describe Product2 do
  it 'should multiply two numbers' do
    expect(Product2.(2).(2)).to eq(4)
  end
end

describe Product do
  it 'should multiply a list of numbers' do
    expect(Product.([1,2])).to eq(2)
    expect(Product.([1,2,3])).to eq(6)
  end
end
