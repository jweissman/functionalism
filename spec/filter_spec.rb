require 'spec_helper'

describe "Filter" do
  it 'should use a proc as a test' do
    expect(Filter[:integer?].([1,1.2,4,5,8])).to eq([1,4,5,8])
    expect((Filter[:odd?] | Sum).(1..100) ).to eq(2500)
  end
end
