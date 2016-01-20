require 'spec_helper'

describe 'Flip' do
  it "should swap the args of a fn" do
    expect(Flip[Append].(3,[1,2])).to eq([1,2,3])
    expect(Flip[Flip[Append]].([1,2],3)).to eq([1,2,3])

    expect(Flip[:-].(2,3)).to eq(1)
  end
end
