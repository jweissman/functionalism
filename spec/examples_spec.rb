require 'spec_helper'
require 'pry'

Dir["example/**/*.rb"].each(&method(:load))

describe "Examples" do
  describe "examples/greeter.rb" do
    subject(:greeter) { Greeter.new }

    it 'should greet Bob and Mary' do
      expect {greeter.greet("bob dobalina")}.
        to output("GREETINGS Dobalina, Bob!\n").to_stdout

      expect {greeter.greet("mary curie")}.
        to output("GREETINGS Curie, Mary!\n").to_stdout
    end

    it 'should deny access to anyone else' do
      expect {greeter.greet("alice hacker")}.
        to output("UNAUTHORIZED\n").to_stdout
    end
  end

  describe "examples/collatz.rb" do
    it 'should compute hailstone sequences' do
      expect( Collatz[10] ).to eq([10,5,16,8,4,2,1])
    end

    it 'should produce hailstone sequences starting from each element of the list' do
      expect( Hailstones[[10,11]] ).to eq(
        [[10,5,16,8,4,2,1],
         [11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]])
    end

    it 'should find the largest hailstone', speed: 'slow' do
      expect(First[LargestHailstone.(1..5_000)]).to eq(3711)
    end
  end

  describe "examples/parser.rb" do
    subject(:parser) { Parser.new }
    it 'should parse an expression' do
      expect(parser.evaluate("2+2")).to eq("4")
      expect(parser.evaluate("2+3+4")).to eq("9")
      expect(parser.evaluate("2-3+4")).to eq("3")

      expect(parser.evaluate("2*2+4")).to eq("8")
      expect(parser.evaluate("2+2*4")).to eq("10")
      expect(parser.evaluate("2*3+2*4")).to eq("14")
    end
  end
end
