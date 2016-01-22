require 'spec_helper'

describe And2 do
  it 'should be true if both sides are true' do
    expect(And2.(true,true)).to be_truthy
    expect(And2.(false,true)).to be_falsy
    expect(And2.(true,false)).to be_falsy
    expect(And2.(false,false)).to be_falsy
  end
end

describe And do
  it 'should && a list of booleans' do
    expect(And.([true,true,true])).to eq(true)
    expect(And.([true,true,false])).to eq(false)
    expect(And.([false,true,false])).to eq(false)
    expect(And.([false,false,false])).to eq(false)
  end
end

