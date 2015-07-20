require "spec_helper"

RSpec.describe TreeDelta::Sorter do

  let(:array) do
    [
      double(:element, identity: "e"),
      double(:element, identity: "a"),
      double(:element, identity: "b"),
      double(:element, identity: "d"),
      double(:element, identity: "c"),
    ]
  end

  let(:enumerator) do
    Enumerator.new do |y|
      y.yield double(:object, identity: "x")
      y.yield double(:object, identity: "a")
      y.yield double(:object, identity: "b")
      y.yield double(:object, identity: "y")
      y.yield double(:object, identity: "c")
      y.yield double(:object, identity: "d")
      y.yield double(:object, identity: "e")
      y.yield double(:object, identity: "z")
    end
  end

  it "sorts elements in the given array by the given enumerator" do
    result = subject.sort(array, enumerator)
    expect(result.map(&:identity)).to eq ["a", "b", "c", "d", "e"]
  end

end
