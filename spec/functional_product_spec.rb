require 'spec_helper'

describe FunctionalProduct2 do
  it 'should compute the product of two functions' do
    expect( FunctionalProduct2[ Double, Triple ].(2) ).to eq(24)
  end
end

describe FunctionalProduct do
  it 'should compute the product of several functions' do
    expect( FunctionalProduct[[ Double, Triple, Cube, Square ]].(1) ).to eq( 6 )

    property_of {integer}.check do |i|
      expect( FunctionalProduct[[ Double, Triple, Cube, Square ]].(i) ).
        to eq( Double[i] * Triple[i] * Cube[i] * Square[i] )
    end
  end
end
