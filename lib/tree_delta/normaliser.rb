module TreeDelta::Normaliser
  class << self

    def normalise_position_changes(nodes)
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

    def normalise_deletions(nodes)
      nodes.reject { |n| nodes.any? { |m| n.parent == m } }
    end

    private

    def position(node)
      node.parent ? node.parent.children.index(node) : 0
    end

  end
end
