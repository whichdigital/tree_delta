require "rspec"
require "pry"
require "tree_delta"

RSpec.configure do |config|
  config.color = true
end

class Node
  attr_reader :id, :children

  def initialize(id, children: [])
    @id, @children = id, children
  end
end

def n(id, *children)
  Node.new(id, children: children)
end
