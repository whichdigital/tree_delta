require "spec_helper"

RSpec.describe TreeDelta::Normaliser do

  describe ".normalise_position_changes" do
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
      result = subject.normalise_position_changes(nodes)
      expect(result.map(&:id)).to eq(["second", "first"])
    end
  end

  describe ".normalise_deletions" do
    let(:nodes) do
      root = double(:node, id: "root", parent: nil, children: [])

      a = double(:node, id: "a", parent: root, children: [])
      b = double(:node, id: "b", parent: root, children: [])
      root.children << a
      root.children << b

      c = double(:node, id: "c", parent: a, children: [])
      a.children << c

      d = double(:node, id: "d", parent: c, children: [])
      c.children << d

      [d, a, root, b, c]
    end

    it "returns the minimum set of nodes that need to be deleted to cascade deletions to subtrees" do
      result = subject.normalise_deletions(nodes)
      expect(result.map(&:id)).to eq(["root"])
    end
  end

end
