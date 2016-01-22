require 'spec_helper'

describe Repeat do
  it 'creates an infinite list of the argument' do
    expect(Take[10, Repeat.(1)]).
      to eq([1,1,1,1,1,1,1,1,1,1])
  end
end
