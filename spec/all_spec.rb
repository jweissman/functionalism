require 'spec_helper'

describe "All" do
  it 'should produce a proc evaluable to true when all encapsulated procs are true' do
    expect(All[:integer?,:even?].(2)).to be_truthy
  end

  it 'should have a synonym for pairs (Both)' do
    expect(Both[:integer?,:even?].(3)).to be_falsy
  end
end
