require 'spec_helper'

describe Functionalism do
  describe "Zip" do
    let(:a) { [1,2,3] }
    let(:b) { [4,5,6] }

    it 'weaves two arrays together' do
      expect(Zip[a,b]).to eq([[1,4],[2,5],[3,6]])
    end
  end

  describe "Unzip" do
    let(:a) { [1,4] }
    let(:b) { [2,5] }
    let(:c) { [3,6] }

    it 'weaves n-arrays together (inverse of Zip)' do
      expect(Unzip[[a,b,c]]).to eq([[1,2,3],[4,5,6]])
    end

    it 'is the inverse of zip' do
      expect(Unzip[Zip[a,b]]).to eq([a,b])
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

  describe "Cycle" do
    it 'creates a circular list from a finite one' do
      expect(Take[10, Cycle.([1,2,3])]).
        to eq([1,2,3,1,2,3,1,2,3,1])
    end
  end

  describe "Repeat" do
    it 'creates an infinite list of the argument' do
      expect(Take[10, Repeat.(1)]).
        to eq([1,1,1,1,1,1,1,1,1,1])
    end
  end

  describe "Initial" do
    it 'gives all but the last element of a collection' do
      expect(Initial.([1,2])).to eq([1])
      expect(Initial.([1,2,3,5,8,11])).to eq([1,2,3,5,8])
      expect(Initial[%w[ hello my baby ]]).to eq(%w[ hello my ])
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

  describe "And" do
    it 'should && a list of booleans' do
      expect(And.([true,true,true])).to eq(true)
      expect(And.([true,true,false])).to eq(false)
    end
  end

  describe "Or" do
    it 'should || a list of booleans' do
      expect(Or.([true,false,true])).to eq(true)
      expect(Or.([true,true,false])).to eq(true)
      expect(Or.([false,false,false])).to eq(false)
    end
  end

  describe "Quicksort" do
    it 'should sort a list' do
      expect(Quicksort.([2,3,1,4])).to eq([1,2,3,4])
      expect(QSort.(['a','c','e','b','d'])).to eq(['a', 'b', 'c', 'd', 'e'])
    end
  end

  describe "SplitAt" do
    it 'should split an array at the given index' do
      expect(SplitAt[3].([1,2,3,4,5])).to eq([[1,2,3],[4,5]])

      expect(SplitAt[0].([1,2,3])).to eq([[],[1,2,3]])
    end
  end

  context "a pipeline" do
    describe 'a tiny string-oriented pipeline' do
      let(:pipeline) do
        :split.(' ') | :capitalize.each | :reverse | :join.(' ')
      end

      it 'should build simple pipelines' do
        expect( pipeline.("hello world") ).to eql("World Hello")
      end
    end

    describe 'for numeric composition with ranges' do
      let(:divisible_by_seven) { ->(x) { x % 7 == 0 } }

      let(:pipeline) do
        Filter[divisible_by_seven] | Sum
      end

      it 'should handle a small set' do
        expect( pipeline.(1..10_000) ).to eql( 7142142 )
      end

      it 'should handle a slightly larger set' do
        expect( pipeline.(1..20_000) ).to eql( 28578571 )
      end

      it 'should handle an even larger set', speed: 'slow' do
        expect( pipeline.(1..30_000) ).to eql( 64279285 )
      end

      it 'should handle a somewhat large set', speed: 'slow' do
        expect( pipeline.(1..40_000) ).to eql( 114294285 )
      end

      it 'should handle a very large set', speed: 'slow' do
        expect( pipeline.(1..100_000) ).to eql( 714264285 )
      end

      it 'should handle a huge set', speed: 'slow' do
        expect( pipeline.(1..250_000) ).to eql( 4464339285 )
      end
    end
  end
end
