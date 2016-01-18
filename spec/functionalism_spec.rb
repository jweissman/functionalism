require 'spec_helper'

describe Functionalism do
  describe "Filter" do
    it 'should use a proc as a test' do
      expect(Filter[:integer?].([1,1.2,4,5,8])).to eq([1,4,5,8])
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

    it 'has an antonym (Append)' do
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

  describe "Zip" do
    let(:a) { [1,2,3] }
    let(:b) { [4,5,6] }

    it 'weaves arrays together' do
      expect(Zip[a,b]).to eq([[1,4],[2,5],[3,6]])
    end
  end

  describe "Maximum" do
    it 'finds the largest of a set' do
      expect(Maximum[[1,2,3]]).to eq(3)
      expect(Maximum[[8,12,14,16]]).to eq(16)
    end
  end

  describe "Minimum" do
    it 'finds the smallest of a set' do
      expect(Minimum[[1,2,3]]).to eq(1)
      expect(Minimum[[8,12,14,16]]).to eq(8)
    end
  end

  describe "Replicate" do
    it 'creates a list of length given by a first arg with items of the second arg' do
      expect(Replicate[2, 'a']).to eq(['a', 'a'])
      expect(Replicate[4, 4]).to eq([4,4,4,4])
    end
  end

  describe "Take" do
    it 'gathers n elements from an array' do
      expect(Take[1, %w[ hello world ]]).to eq(["hello"])
      expect(Take[2, [5,6,7,8,9,10]]).to eq([5,6])
    end
  end

  describe "TakeWhile" do
    it 'gathers elements while condition holds' do
      expect(TakeWhile[:<.(2), [-1,0,1,2,3]]).to eq([-1,0,1])
    end
  end

  describe "Drop" do
    it 'ignores n elements from an array' do
      expect(Drop[1, %w[ hello world ]]).to eq(["world"])
      expect(Drop[2, [5,6,7,8,9,10]]).to eq([7,8,9,10])
    end
  end

  describe "DropWhite" do
    it 'ignores elements while condition holds' do
      expect(DropWhile[:<.(2), [-1,0,1,2,3]]).to eq([2,3])
    end
  end

  describe "Iterate" do
    let(:powers_of_two) { Iterate[:*.(2)].(1) }
    it 'should create a generator factory' do
      expect(powers_of_two.take(5)).to eq([1,2,4,8,16])
    end
  end

  describe "Reverse" do
    it 'should invert the order of a collection' do
      expect(Reverse.([1,2,3])).to eq([3,2,1])
    end
  end

  describe "Last" do
    it 'should indicate the last element in a collection' do
      expect(Last.([1,2])).to eq(2)
      expect(Last.([1,2,3,5,8,11])).to eq(11)
      expect(Last[%w[ hello my baby ]]).to eq('baby')
    end
  end

  describe "Sum" do
    it 'should sum a list of numbers' do
      expect(Sum.([1,2])).to eq(3)
      expect(Sum.([1,2,3])).to eq(6)
    end
  end

  describe "Product" do
    it 'should multiply a list of numbers' do
      expect(Product.([1,2])).to eq(2)
      expect(Product.([1,2,3])).to eq(6)
    end
  end

  context "a pipeline" do
    describe 'a basic pipeline' do
      let(:pipeline) do
        :split.(' ') | :capitalize.each | :reverse | :join.(' ')
      end

      it 'should build simple pipelines' do
        expect( pipeline.("hello world") ).to eql("World Hello")
      end
    end

    describe 'for numeric composition with ranges' do
      let(:mod_seven) { ->(x) { x % 7 == 0 } }

      let(:pipeline) do
        Filter[mod_seven] | Sum
      end

      it 'should handle a small set' do
        expect( pipeline.(1..10_000) ).to eql( 7142142 )
      end

      it 'should handle a slightly larger set' do
        expect( pipeline.(1..20_000) ).to eql( 28578571 )
      end

      it 'should handle an even larger set' do
        expect( pipeline.(1..30_000) ).to eql( 64279285 )
      end

      it 'should handle a somewhat large set' do
        expect( pipeline.(1..40_000) ).to eql( 114294285 )
      end

      xit 'should handle a very large set' do
        expect( pipeline.(1..100_000) ).to eql( 114294285 )
      end
    end
  end
end
