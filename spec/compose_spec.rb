require 'spec_helper'

describe "Compose" do
  it 'should compose procs/symbols' do
    expect(Compose[:upcase,:reverse].('hello')).to eq("OLLEH")
    expect(Compose[->(x) {x*2}, ->(x) {x**3}].(4)).to eq(512)
  end
end
