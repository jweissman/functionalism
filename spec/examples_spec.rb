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
end
