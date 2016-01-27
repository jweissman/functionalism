require 'spec_helper'

describe FixedPoint do
  let(:polynomial_with_fixed_point) do
    ->(x) { (x**2) - (3*x) + 4 }
  end

  it 'should identify a known fixed point of a polynomial function' do
    expect(FixedPoint[polynomial_with_fixed_point,1]).to eq(2)
    expect(FixedPoint[polynomial_with_fixed_point,2]).to eq(2)

    expect(FixedPoint[Halve,0]).to eq(0)
    expect(FixedPoint[Double,0]).to eq(0)
    expect(FixedPoint[Square,1]).to eq(1)
    expect(FixedPoint[Cube,1]).to eq(1)
  end

  context 'for rapidly diverging functions' do
    it 'should identify a fixed point at infinity' do
      expect(FixedPoint[Square,2]).to eq(Infinity)
      expect(FixedPoint[Cube,2]).to eq(Infinity)
    end
  end
end
