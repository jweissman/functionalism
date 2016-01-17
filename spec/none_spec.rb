require 'spec_helper'

describe "None" do
  it 'should produce a proc evaluable to true when all encapsulated procs are false' do
    expect(None[:zero?,:even?].(2)).to be_falsy
  end
end

