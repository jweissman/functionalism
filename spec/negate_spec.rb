require 'spec_helper'

describe Negate do
  let(:greater_than_2) { :>.(2) }

  it 'should invert the logical value of a predicate' do
    expect( (-greater_than_2).(1) ).to eq(true)
    expect( (-greater_than_2).(2) ).to eq(true)
    expect( (-greater_than_2).(3) ).to eq(false)
  end

  describe Compose2[Negate, Negate] do
    let(:double_negate) { Compose2[Negate,Negate] }

    it 'should be id for predicates' do
      doubly_negated_gt_2 = double_negate.(greater_than_2)

      property_of { integer }.check do |i|
        expect( doubly_negated_gt_2.(i) ).to eq(greater_than_2.(i))
      end
    end
  end
end
