require 'spec_helper'

describe List do
  it 'assembles lists' do
    expect(List[3]).to eq([3])
    expect(List[1,2,3]).to eq([1,2,3])
  end
end
