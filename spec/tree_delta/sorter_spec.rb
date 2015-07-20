require "spec_helper"

RSpec.describe TreeDelta::Sorter do

  let(:array) do
    [
      double(:element, id: "e"),
      double(:element, id: "a"),
      double(:element, id: "b"),
      double(:element, id: "d"),
      double(:element, id: "c"),
    ]
  end

  let(:enumerator) do
    Enumerator.new do |y|
      y.yield double(:object, id: "x")
      y.yield double(:object, id: "a")
      y.yield double(:object, id: "b")
      y.yield double(:object, id: "y")
      y.yield double(:object, id: "c")
      y.yield double(:object, id: "d")
      y.yield double(:object, id: "e")
      y.yield double(:object, id: "z")
    end
  end

  it "sorts elements in the given array by the given enumerator" do
    result = subject.sort(array, enumerator)
    expect(result.map(&:id)).to eq ["a", "b", "c", "d", "e"]
  end

end
