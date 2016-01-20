require 'spec_helper'

describe Compose do
  it 'should compose multiple procs/symbols' do
    expect(Compose[[:upcase,:reverse,:*.(2)]].('hello')).to eq("OLLEHOLLEH")
    expect(Compose[[:*.(2), :**.(3), :+.(10)]].(4)).to eq(522)
  end

  it 'should compose fns' do
    init_prime = Compose2[Compose2[Reverse,Tail], Reverse]
    init_prime_prime = Compose[[Reverse,Tail,Reverse]]

    expect( init_prime.([1,2,3]) ).to eq([1,2])
    expect( init_prime_prime.([1,2,3]) ).to eq([1,2])
  end

  it 'should have a synonym (Pipe)' do
    expect(Pipe[[:+.(1), :*.(2)]].(1)).to eq(4)
    expect(Pipe[[Reverse,Tail,Reverse]].([2,4,6,8])).to eq([2,4,6])
  end
end
