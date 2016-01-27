require 'spec_helper'

describe Filter do
  it 'should use a proc as a test' do
    expect(Filter[:integer?].([1,1.2,4,5,8])).to eq([1,4,5,8])
    expect((Filter[:odd?] | Sum).(1..100) ).to eq(2500)
  end

  it 'should work for arrays of arrays' do
    long = ->(xs) { Length[xs] > 2 }
    arr = [ [ 1, 2, 3 ], [ 4 ], [ 5, 6 ] ]
    expect( Filter[long].(arr) ).to eq([[1,2,3]])
  end

  it 'should work for infinite sequences' do
    # expect( Filter[:even?].(Iterate[Successor,1]) ).to be_an(Enumerator)
    # expect( First[ Filter[:even?].(Iterate[Successor,1]) ] ).to eq([2])
    expect( Take[2, Filter[:even?].(Iterate[Successor,1])] ).to eq([2,4])
    expect( Take[5, Filter[:even?].(Iterate[Successor,1])]).to eq([2,4,6,8,10])
  end
end
