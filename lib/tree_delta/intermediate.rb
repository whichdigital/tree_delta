class TreeDelta::Intermediate

  attr_reader :from, :to

  def initialize(from:, to:)
    @from, @to = from, to
  end

  def creates
    Enumerator.new do |y|
      subtract(to_nodes, from_nodes).each do |node|
        y.yield TreeDelta::Operation.new(
          type:     :create,
          id:       node.id,
          value:    node.value,
          parent:   parent_id(node),
          position: position(node)
        )
      end
    end
  end

  def updates
    [] # TODO
  end

  def deletes
    Enumerator.new do |y|
      subtract(from_nodes, to_nodes).each do |node|
        y.yield TreeDelta::Operation.new(
          type: :delete,
          id:   node.id
        )
      end
    end
  end

  def detaches
    Enumerator.new do |y|
      moves.each do |node|
        y.yield TreeDelta::Operation.new(
          type: :detach,
          id:   node.id
        )
      end
    end
  end

  def attaches
    Enumerator.new do |y|
      moves.each do |node|
        y.yield TreeDelta::Operation.new(
          type:     :attach,
          id:       node.id,
          parent:   parent_id(node),
          position: position(node)
        )
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

  def nodes(tree)
    traversal = TreeDelta::Traversal.new(
      type:      :depth_first,
      direction: :left_to_right,
      order:     :pre
    )

    traversal.traverse(tree).to_a
  end

  def subtract(a, b)
    a.reject { |e| b.any? { |f| e.id == f.id } }
  end

  def parent_id(node)
    node && node.parent ? node.parent.id : nil
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
    to_node && parent_id(to_node) != parent_id(from_node)
  end

  def normalised_position_changes
    groups = position_changes.group_by { |n| parent_id(n) }
    groups.map { |_, nodes| TreeDelta::Normaliser.normalise(nodes) }.flatten
  end

  def position_changes
    nodes = from_nodes.select { |n| changed_position?(n) }
    nodes.map { |from_node| to_node_for(from_node) }
  end

  def changed_position?(from_node)
    to_node = to_node_for(from_node)

    to_node &&
      parent_id(from_node) == parent_id(to_node) &&
      position(from_node) != position(to_node)
  end

  def to_node_for(from_node)
    to_nodes.detect { |n| n.id == from_node.id }
  end

end
