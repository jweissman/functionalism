require 'spec_helper'

describe "Call" do
  it 'should invoke the fn with the supplied args' do
    expect(Call[:+,[2,2]]).to eq(4)
  end
end
