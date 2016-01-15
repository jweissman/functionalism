require 'spec_helper'
require 'functionalism'

describe Functionalism do
  describe "Identity" do
    it 'should be the id function' do
      expect(Identity.(1)).to eq(1)
      expect(Identity.('foo')).to eq('foo')
    end
  end

  describe "Compose" do
    it 'should compose procs/symbols' do
      expect(Compose[:upcase,:reverse].('hello')).to eq("OLLEH")
      expect(Compose[->(x) {x*2}, ->(x) {x**3}].(4)).to eq(512)
    end
  end

  describe "Splat" do
    it 'should fan-out' do
      expect(Splat[:upcase,:reverse,:capitalize].('hello')).to eq(["HELLO", "olleh", "Hello"])
      expect(Splat[->(x) { x*2}, ->(x) { x**3 }].(5)).to eq([10, 125])
    end
  end

  describe "All" do
    it 'should produce a proc evaluable to true when all encapsulated procs are true' do
      expect(All[:integer?,:even?].(2)).to be_truthy
      expect(All[:integer?,:even?].(3)).to be_falsy
    end
  end

  describe "Any" do
    it 'should produce a proc evaluable to true when any encapsulated procs are true' do
      expect(Any[:zero?,:odd?].(1)).to be_truthy
      expect(Any[:zero?,:odd?].(2)).to be_falsy
    end
  end

  describe "None" do
    it 'should produce a proc evaluable to true when all encapsulated procs are false' do
      expect(None[:zero?,:even?].(2)).to be_falsy
      expect(None[:zero?,:even?].(3)).to be_truthy
    end
  end

  describe "Filter" do
    it 'should compose filters' do
      expect(Filter[:integer?,:even?].([1,1.2,4,5,8])).to eq([4,8])
    end
  end

  context "a pipeline" do
    let(:pipeline) do
      :split.(' ') | :capitalize.each | :reverse | :join.(' ')
    end

    it 'should build simple pipelines' do
      expect( pipeline.("hello world") ).to eql("World Hello")
    end
  end
end
