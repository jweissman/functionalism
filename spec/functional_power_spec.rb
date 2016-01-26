require 'spec_helper'

describe FunctionalPower do
  it 'should compute n-fold composition (a function composed with itself n times)' do
    expect( FunctionalPower[Double][0].(2) ).to eql( 2 )
    expect( FunctionalPower[Double][1].(2) ).to eql( Double[2] )
    expect( FunctionalPower[Double][2].(2) ).to eql( Compose2[Double,Double][2] )
    expect( FunctionalPower[Double][3].(2) ).to eql( Compose[[Double,Double,Double]][2] )
  end
end
