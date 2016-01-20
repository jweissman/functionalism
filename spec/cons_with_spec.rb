require 'spec_helper'

describe ConsWith do
  let(:double) { ->(x) { x * 2 } }
  it 'assembles lists while applying a fn' do
    expect(ConsWith[double][Cons[[], 2], 3]).to eq([6, 2])
  end
end
