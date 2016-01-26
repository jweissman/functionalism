require 'spec_helper'

describe Detect do
  it 'should find a matching element using a proc as a test' do
    expect(Detect[:integer?].([3.14,1.18,3])).to eq(3)
  end
end
