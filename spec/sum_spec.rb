require 'spec_helper'

describe Sum2 do
  it 'should add two numbers' do
    expect(Sum2.(1).(2)).to eq(3)
    expect(Sum2.(5).(-5)).to eq(0)
  end
end

describe Sum do
  it 'should sum a list of numbers' do
    expect(Sum.([1,2])).to eq(3)
    expect(Sum.([1,2,3])).to eq(6)
  end
end
