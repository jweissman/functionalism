require 'spec_helper'

describe Identity do
  it 'should be the id function' do
    expect(Identity.(1)).to eq(1)
    expect(Identity.('foo')).to eq('foo')
  end
end
