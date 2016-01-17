require 'spec_helper'

describe "Any" do
  it 'should produce a proc evaluable to true when any encapsulated procs are true' do
    expect(Any[:zero?,:odd?].(1)).to be_truthy
  end
end
