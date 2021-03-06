require 'spec_helper'

describe Iterate do
  let(:powers_of_two) { Iterate[:*.(2)].(1) }
  it 'should create a generator factory' do
    expect(Take[5, powers_of_two]).to eq([1,2,4,8,16])
  end
end
