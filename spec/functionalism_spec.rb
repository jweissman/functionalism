require 'spec_helper'

describe Functionalism do
  describe "All" do
    it 'should produce a proc evaluable to true when all encapsulated procs are true' do
      expect(All[:integer?,:even?].(2)).to be_truthy
      expect(Both[:integer?,:even?].(3)).to be_falsy
    end
  end

  describe "Any" do
    it 'should produce a proc evaluable to true when any encapsulated procs are true' do
      expect(Any[:zero?,:odd?].(1)).to be_truthy
      expect(Some[:zero?,:odd?].(2)).to be_falsy
    end
  end

  describe "None" do
    it 'should produce a proc evaluable to true when all encapsulated procs are false' do
      expect(None[:zero?,:even?].(2)).to be_falsy
      expect(Neither[:zero?,:even?].(3)).to be_truthy
    end
  end

  describe "Filter" do
    it 'should compose filters' do
      expect(Filter[:integer?,:even?].([1,1.2,4,5,8])).to eq([4,8])
    end
  end

  describe "Iterate" do
    let(:powers_of_two) { Iterate[:*.(2)].(1) }
    it 'should create a generator factory' do
      expect(powers_of_two.take(5)).to eq([1,2,4,8,16])
    end
  end

  describe "Cons" do
    it 'assembles lists' do
      expect(Cons[1, Cons[2,3]]).to eq([1,2,3])
    end

    describe "Fold[Cons]" do
      it 'should be id for lists' do
        expect(Fold[Cons].([]).([1,2,3])).to eq([1,2,3])
      end
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
