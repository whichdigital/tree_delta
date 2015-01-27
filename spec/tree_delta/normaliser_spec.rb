require "spec_helper"

describe TreeDelta::Normaliser do

  let(:nodes) do
    root = double(:node, id: "root", parent: nil, children: [])

    first  = double(:node, id: "first",  parent: root, children: [])
    second = double(:node, id: "second", parent: root, children: [])
    third  = double(:node, id: "third",  parent: root, children: [])
    fourth = double(:node, id: "fourth", parent: root, children: [])

    root.children << first
    root.children << second
    root.children << third
    root.children << fourth

    [third, second, fourth, first]
  end

  it "returns the minimum set of nodes that need to move in order to position all nodes correctly" do
    result = subject.normalise(nodes)
    expect(result.map(&:id)). to eq(["second", "first"])
  end

end
