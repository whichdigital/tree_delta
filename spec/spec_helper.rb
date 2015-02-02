require "rspec"
require "pry"
require "ascii_tree"
require "tree_delta"

RSpec.configure do |config|
  config.color = true
end

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

# Delete me after tests have been ported to use AsciiTree
def n(id, *children)
  Node.new(id, children: children)
end
