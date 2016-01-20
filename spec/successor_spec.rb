require 'spec_helper'

describe "Successor" do
  it 'indicates the next natural number' do
    expect(Successor[5]).to eql(6)
    expect(Successor[128]).to eql(129)
  end

  it 'has an antonym (Predecessor)' do
    expect(Predecessor[10]).to eq(9)
  end

  describe 'Succ | Pred' do
    it 'is id for integers' do
      property_of { integer }.check do |i|
        expect((Succ | Pred)[i]).to eq(i)
      end
    end
  end
end
