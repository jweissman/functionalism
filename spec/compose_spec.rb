require 'spec_helper'

describe "Compose2" do
  let(:nullary) { -> { rand }} 
  it 'should compose two procs/syms' do
    expect(Compose2[:downcase, :reverse].("Hi there!")).to eq("!ereht ih")
    expect(Compose2[nullary, :%.(10)].()).to be_a(Numeric)
  end
end

describe "Compose" do
  it 'should compose multiple procs/symbols' do
    expect(Compose[:upcase,:reverse,:*.(2)].('hello')).to eq("OLLEHOLLEH")
    expect(Compose[:*.(2), :**.(3), :+.(10)].(4)).to eq(522)
  end
end
