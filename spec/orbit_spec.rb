require 'spec_helper'

describe Orbit do
  it 'should fan-out (gather projections of an element)' do
    expect(Orbit[[:upcase,:reverse,:capitalize],('hello')]).to eq(["HELLO", "olleh", "Hello"])
    expect(Orbit[[->(x) { x*2}, ->(x) { x**3 }],(5)]).to eq([10, 125])
  end
end
