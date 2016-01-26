require 'spec_helper'

describe Replicate do
  it 'creates a list of length given by a first arg with items of the second arg' do
    expect(Replicate[2, 'a']).to eq(['a', 'a'])
    expect(Replicate[4, 4]).to eq([4,4,4,4])
    expect(Replicate[3,[]]).to eq([ [], [], [] ])
  end
end
