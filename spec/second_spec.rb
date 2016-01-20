require 'spec_helper'

describe Second do
  it 'returns the second element of a collection' do
    expect(Second[[1,2]]).to eq(2)
    expect(Second[%w[ hello world ]]).to eq('world')
  end
end
