require 'spec_helper'

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
    ).to eq(%w[ cook bear apple ])
  end

  it 'has an antonym (Append)' do
    expect(
      Append[Append[Append[[], 'apple'], 'bear'], 'cook']
    ).to eq(%w[ apple bear cook])
  end

  describe "Foldl[Cons,[]]" do
    it 'is id for collections' do
      property_of { array(10) { branch :integer, :string, :float } }.check do |i|
        expect(Foldl[Cons].([]).([i])).to eq(Identity[[i]])
      end
    end
  end

  describe "First[Prepend[[],x]]" do
    it 'is id for atoms' do
      property_of { branch :integer, :string, :float }.check do |i|
        expect(First[Prepend[[],i]]).to eq(Identity[i])
      end
    end
  end
end
