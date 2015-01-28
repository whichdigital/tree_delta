class TreeDelta::Traversal < Enumerator

  attr_reader :direction, :order

  def initialize(direction:, order:)
    @direction = direction
    @order     = order
  end

  def traverse(node)
    Enumerator.new do |y|
      if node
        y.yield(node) if order == :pre

        ordered_children(node).each do |child|
          traverse(child).each { |n| y.yield(n) }
        end

        y.yield(node) if order == :post
      end
    end
  end

  private

  def ordered_children(node)
    if direction == :left_to_right
      node.children
    elsif direction == :right_to_left
      node.children.reverse
    end
  end

end
