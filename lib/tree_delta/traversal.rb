class TreeDelta::Traversal < Enumerator

  attr_reader :type, :direction, :order

  def initialize(type:, direction:, order:)
    @type      = type
    @direction = direction
    @order     = order

    raise NotImplementedError if type != :depth_first
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
