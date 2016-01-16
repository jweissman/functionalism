require 'spec_helper'

describe Functionalism do
  describe "SendEach" do
    it "should send a method to each of the procs" do
      expect(SendEach[:map,:upcase,:downcase].('okAY')).to eq(%w[ OKAY okay ])
    end
  end
end
