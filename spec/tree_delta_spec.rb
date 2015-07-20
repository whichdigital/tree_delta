require "spec_helper"

RSpec.describe TreeDelta do

  class Node
    attr_reader :identity, :children, :parent, :value

    def initialize(first, children: [])
      if Array === identity
        @identity, @value = *first
      else
        @identity, @value = *first, "value"
      end

      @children = children

      children.each do |child|
        child.parent = self
      end
    end

    protected

    attr_writer :parent
  end

  it "works for the example in the readme" do
    alpha = Node.new("alpha", children: [
      Node.new("a", children: [
        Node.new("c"),
        Node.new("d")
      ]),
      Node.new("b", children: [
        Node.new("e")
      ])
    ])

    beta = Node.new("beta", children: [
      Node.new("a", children: [
        Node.new("d"),
        Node.new("c")
      ]),
      Node.new("e")
    ])

    delta = TreeDelta.new(from: alpha, to: beta)

    operations = []

    delta.each do |operation|
      operations << operation
    end

    expect(operations).to eq [
      TreeDelta::Operation.new(type: :detach, identity: "e"),
      TreeDelta::Operation.new(type: :detach, identity: "d"),
      TreeDelta::Operation.new(type: :detach, identity: "a"),
      TreeDelta::Operation.new(type: :delete, identity: "alpha"),
      TreeDelta::Operation.new(type: :create, identity: "beta", value: "value", position: 0),
      TreeDelta::Operation.new(type: :attach, identity: "a", parent: "beta", position: 0),
      TreeDelta::Operation.new(type: :attach, identity: "d", parent: "a", position: 0),
      TreeDelta::Operation.new(type: :attach, identity: "e", parent: "beta", position: 1)
    ]
  end
end
