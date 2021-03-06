require 'spec_helper'

describe Cycle do
  it 'creates a circular list from a finite one' do
    expect(Take[10, Cycle.([1,2,3])]).
      to eq([1,2,3,1,2,3,1,2,3,1])
  end

  # it 'is id for infinite lists' do
  #   expect(Cycle.(Iterate[Succ,1])).to eq(Iterate[Succ,1])
  # end
end
