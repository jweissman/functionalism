require 'spec_helper'

describe Functionalism do
  describe "Splat" do
    it 'should fan-out' do
      expect(Splat[:upcase,:reverse,:capitalize].('hello')).to eq(["HELLO", "olleh", "Hello"])
      expect(Splat[->(x) { x*2}, ->(x) { x**3 }].(5)).to eq([10, 125])
    end
  end
end
