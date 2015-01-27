require "rspec"
require "pry"
require "tree_delta"

RSpec.configure do |config|
  config.color = true
end

class Node
  attr_reader :id, :children, :parent

  def initialize(id, children: [])
    @id, @children = id, children

    children.each do |child|
      child.parent = self
    end
  end

  def value
    "value"
  end

  protected

  attr_writer :parent
end

def n(id, *children)
  Node.new(id, children: children)
end
