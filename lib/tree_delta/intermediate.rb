class TreeDelta::Intermediate

  attr_reader :from, :to

  def initialize(from:, to:)
    @from, @to = from, to
  end

  def creates
    Enumerator.new do |y|
      additions.each do |node|
        y.yield TreeDelta::Operation.new(
          type:     :create,
          identity: node.identity,
          value:    node.value,
          parent:   parent_identity(node),
          position: position(node)
        )
      end
    end
  end

  def updates
    Enumerator.new do |y|
      updated_nodes.each do |node|
        y.yield TreeDelta::Operation.new(
          type:     :update,
          identity: node.identity,
          value:    node.value,
        )
      end
    end
  end

  def deletes
    Enumerator.new do |y|
      normalised_deletions.each do |node|
        y.yield TreeDelta::Operation.new(
          type:     :delete,
          identity: node.identity
        )
      end
    end
  end

  def detaches
    Enumerator.new do |y|
      moves.each do |node|
        unless previous_root?(node)
          y.yield TreeDelta::Operation.new(
            type:     :detach,
            identity: node.identity
          )
        end
      end
    end
  end

  def attaches
    Enumerator.new do |y|
      moves.each do |node|
        unless root?(node)
          y.yield TreeDelta::Operation.new(
            type:     :attach,
            identity: node.identity,
            parent:   parent_identity(node),
            position: position(node)
          )
        end
      end
    end
  end

  private

  def from_nodes
    @from_nodes ||= nodes(from)
  end

  def to_nodes
    @to_nodes ||= nodes(to)
  end

  def additions
    subtract(to_nodes, from_nodes)
  end

  def updated_nodes
    to_nodes.select do |to_node|
      from_node = from_node_for(to_node)
      from_node && from_node.value != to_node.value
    end
  end

  def normalised_deletions
    TreeDelta::Normaliser.normalise_deletions(deletions)
  end

  def deletions
    subtract(from_nodes, to_nodes)
  end

  def nodes(tree)
    traversal = TreeDelta::Traversal.new(direction: :left_to_right, order: :pre)
    traversal.traverse(tree).to_a
  end

  def subtract(a, b)
    a.reject { |e| b.any? { |f| e.identity == f.identity } }
  end

  def parent_identity(node)
    node && node.parent ? node.parent.identity : nil
  end

  def position(node)
    node.parent ? node.parent.children.index(node) : 0
  end

  def moves
    @moves ||= parent_changes + normalised_position_changes
  end

  def parent_changes
    nodes = from_nodes.select { |n| changed_parent?(n) }
    nodes.map { |from_node| to_node_for(from_node) }
  end

  def changed_parent?(from_node)
    to_node = to_node_for(from_node)
    to_node && parent_identity(to_node) != parent_identity(from_node)
  end

  def normalised_position_changes
    groups = position_changes.group_by { |n| parent_identity(n) }

    groups.map do |_, nodes|
      TreeDelta::Normaliser.normalise_position_changes(nodes)
    end.flatten
  end

  def position_changes
    nodes = from_nodes.select { |n| changed_position?(n) }
    nodes.map { |from_node| to_node_for(from_node) }
  end

  def changed_position?(from_node)
    to_node = to_node_for(from_node)

    to_node &&
      parent_identity(from_node) == parent_identity(to_node) &&
      position(from_node) != position(to_node)
  end

  def from_node_for(to_node)
    from_nodes.detect { |n| n.identity == to_node.identity }
  end

  def to_node_for(from_node)
    to_nodes.detect { |n| n.identity == from_node.identity }
  end

  def root?(to_node)
    !to_node.parent
  end

  def previous_root?(to_node)
    from_node = from_node_for(to_node)
    !from_node.parent
  end

end
