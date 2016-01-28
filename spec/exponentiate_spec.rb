require 'spec_helper'

describe Exponentiate do
  it 'should compute the n-fold product of a function' do
    expect( Exponentiate[:*.(2)].(2).(3) ).to eq(36)
  end
end
