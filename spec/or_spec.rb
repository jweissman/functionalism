require 'spec_helper'

describe Or do
  it 'should || a list of booleans' do
    expect(Or.([true,false,true])).to eq(true)
    expect(Or.([true,true,false])).to eq(true)
    expect(Or.([false,false,false])).to eq(false)
  end
end
