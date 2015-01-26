require "spec_helper"

describe TreeDelta do
  class Node
    attr_reader :id, :children

    def initialize(id, children: [])
      @id, @children = id, children
    end
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
      # TODO
      #
      # detach 'e'
      # detach 'd'
      # detach 'a'
      # delete 'alpha'
      # create 'beta' as root
      # attach 'a' to 'beta' at position 0
      # attach 'd' to 'a' at position 0
      # attach 'e' to 'beta' at position 1
    ]
  end
end
