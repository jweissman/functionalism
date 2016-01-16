require 'spec_helper'
require 'functionalism'

describe Symbol do
  context 'behaves like its own #to_proc for composition and currying' do
    it 'handles string operations' do
      cap_and_reverse = (:capitalize | :reverse)
      expect( cap_and_reverse.("hello") ).to eq("olleH")
    end

    it 'handles array operations' do
      reverse_and_join = :reverse.each | :join.(":")
      expect( reverse_and_join.(%w[ ola hombre ]) ).to eq("alo:erbmoh")
    end
  end

  describe "#each" do
    it 'applies something to every element in an array' do
      cap_each = :capitalize.each
      expect( cap_each.(%w[ foo bar ])).to eq(["Foo", "Bar"])
    end
  end

  describe "#elements" do
    it 'is a shorthand for building a proc to call a method with *each* of the args' do
      expect{(:split.(' ') | :capitalize.each | :reverse | :print.elements).('bar baz')}.to output('BazBar').to_stdout
    end
  end

  describe "#call" do
    it 'is a shorthand for currying' do
      expect(:+.(1).(2)).to eq(3)
    end
  end
end
