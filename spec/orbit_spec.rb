require 'spec_helper'

describe Orbit do
  let(:pythagoras) { ->(a,b) { Math.sqrt( (a ** 2) + (b ** 2 )) } }
  it 'should fan-out (gather projections of an element)' do
    expect(Orbit[[:upcase,:reverse,:capitalize],('hello')]).to eq(["HELLO", "olleh", "Hello"])
    expect(Orbit[[->(x) { x*2}, ->(x) { x**3 }],(5)]).to eq([10, 125])
  end

  it 'should handle functions of more than one argument' do
    expect(Orbit[[pythagoras, pythagoras]].([3,4])).to eq([5,5])
  end
end
