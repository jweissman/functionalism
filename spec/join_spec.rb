require 'spec_helper'

describe Join do
  it 'should be equivalent to .join' do
    expect(Join[%w[ a b c ]]).to eq('abc')
  end
end
