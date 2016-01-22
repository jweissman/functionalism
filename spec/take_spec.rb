require 'spec_helper'

describe "Take" do
  it 'gathers n elements from an array' do
    expect(Take[1, %w[ hello world ]]).to eq(["hello"])
    expect(Take[2, [5,6,7,8,9,10]]).to eq([5,6])
  end
end

describe "TakeWhile" do
  it 'gathers elements while condition holds' do
    expect(TakeWhile[:<.(2), [-1,0,1,2,3]]).to eq([-1,0,1])
  end
end

describe "Drop" do
  it 'ignores n elements from an array' do
    expect(Drop[1, %w[ hello world ]]).to eq(["world"])
    expect(Drop[2, [5,6,7,8,9,10]]).to eq([7,8,9,10])
  end
end

describe "DropWhite" do
  it 'ignores elements while condition holds' do
    expect(DropWhile[:<.(2), [-1,0,1,2,3]]).to eq([2,3])
  end
end
