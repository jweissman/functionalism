require 'spec_helper'

describe "First" do
  it 'should return the first entry in an array' do
    expect(First[[1,2,3]]).to eq(1)
    expect(First[%w[hello world]]).to eq('hello')
  end

  it 'should return the beginning element in an enumerated sequence' do
    expect(First[Repeat[2]]).to eq(2)
  end

  it 'should return the start of a range' do
    expect(First[1..3]).to eq(1)
  end

  it 'has a synonym (Head)' do
    expect(Head[%w[ whomever it may concern ]]).to eq('whomever')
  end

  it 'has an antonym (Rest)' do
    expect(Rest.([2,3,4])).to eq([3,4])
    expect(Rest.(%w[hello world])).to eq(['world'])
  end
end
