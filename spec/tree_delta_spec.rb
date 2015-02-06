require "spec_helper"

describe TreeDelta do

  class Node
    attr_reader :id, :children, :parent, :value

    def initialize(first, children: [])
      if Array === id
        @id, @value = *first
      else
        @id, @value = *first, "value"
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
      TreeDelta::Operation.new(type: :detach, id: "e"),
      TreeDelta::Operation.new(type: :detach, id: "d"),
      TreeDelta::Operation.new(type: :detach, id: "a"),
      TreeDelta::Operation.new(type: :delete, id: "alpha"),
      TreeDelta::Operation.new(type: :create, id: "beta", value: "value", position: 0),
      TreeDelta::Operation.new(type: :attach, id: "a", parent: "beta", position: 0),
      TreeDelta::Operation.new(type: :attach, id: "d", parent: "a", position: 0),
      TreeDelta::Operation.new(type: :attach, id: "e", parent: "beta", position: 1)
    ]
  end
end
