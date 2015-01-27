module TreeDelta::Normaliser

  def self.normalise(nodes)
    moving_nodes = []

    previous_node = nil
    nodes.each do |current_node|
      if previous_node && position(current_node) < position(previous_node)
        moving_nodes << current_node
      end
      previous_node = current_node
    end

    moving_nodes
  end

  def self.position(node)
    node.parent ? node.parent.children.index(node) : 0
  end

end
