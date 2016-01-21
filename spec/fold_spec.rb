require 'spec_helper'

describe "Fold" do
  it 'should inject' do
    expect( Fold[:+,0].([2,3]) ).to eq(5)
    expect( Fold[:*,1].([10,3]) ).to eq(30)
    expect( Fold[:+,''].(%w[ hey yo ]) ).to eq("heyyo")
  end

  it 'should infer the initial type in common cases' do
    expect( Fold[:+].([3,4])).to eq(7)
    expect( Fold[Compose2].([Filter[:even?],Sum]).([2,3,4])).to eq(6)
    expect( Fold[:merge].([{a: '123'}, {b: 5.4}])).to eq({a: '123', b: 5.4})
  end

  it 'should have a left-handed variant (Foldl)' do
    expect( Foldl[:+,0].([2,3]) ).to eq(5)
    expect( Foldl[:+,''].(%w[ hey yo ]) ).to eq("yohey")

    expect( Foldl[Compose2].([Sum,Filter[:even?]]).([2,3,4])).to eq(6)
  end
end
