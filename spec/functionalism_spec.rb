require 'spec_helper'

describe Functionalism do
  describe "Filter" do
    it 'should compose filters' do
      expect(Filter[:integer?,:even?].([1,1.2,4,5,8])).to eq([4,8])
    end
  end

  describe "Cons" do
    it 'assembles lists' do
      aggregate_failures 'constructing lists' do
        expect(
          Cons[Cons[Cons[[], 3], 2], 1]
        ).to eq([1,2,3])

        expect(
          Cons[Cons[Cons[[], [3]], [2]], [1]]
        ).to eq([[1],[2],[3]])
      end
    end

    it 'has a synonym (Prepend)' do
      expect(
        Prepend[Prepend[Prepend[[], 'apple'], 'bear'], 'cook']
      ).to eq(%w[ cook bear apple ]) #[['apple'],[2],[3]])
    end

    it 'has a antonym (Prepend)' do
      expect(
        Append[Append[Append[[], 'apple'], 'bear'], 'cook']
      ).to eq(%w[ apple bear cook])
    end

    describe "Foldl[Cons] []" do
      it 'should be id for lists' do
        expect(Foldl[Cons].([]).([1,2,3])).to eq([1,2,3])
      end
    end
  end

  describe "ConsWith" do
    let(:double) { ->(x) { x * 2 } }
    it 'assembles lists while applying a fn' do
      expect(ConsWith[double][Cons[[], 2], 3]).to eq([6, 2])
    end
  end

  describe "Iterate" do
    let(:powers_of_two) { Iterate[:*.(2)].(1) }
    it 'should create a generator factory' do
      expect(powers_of_two.take(5)).to eq([1,2,4,8,16])
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
