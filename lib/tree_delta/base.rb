class TreeDelta < Enumerator

  attr_reader :from, :to

  def initialize(from:, to:)
    @from, @to = from, to
  end

  def each(&block)
    deletes_and_detaches.each { |m| yield m }
    creates_and_attaches.each { |m| yield m }
    updates.each              { |m| yield m }
  end

  private

  def deletes_and_detaches
    traversal = Traversal.new(
      type:      :depth_first,
      direction: :right_to_left,
      order:     :post
    )

    enumerator = traversal.traverse(from)

    Sorter.sort(deletes + detaches, enumerator)
  end

  def creates_and_attaches
    traversal = Traversal.new(
      type:      :depth_first,
      direction: :left_to_right,
      order:     :pre
    )

    enumerator = traversal.traverse(to)

    Sorter.sort(creates + attaches, enumerator)
  end

  def creates
    []
  end

  def updates
    []
  end

  def deletes
    []
  end

  def detaches
    []
  end

  def attaches
    []
  end

end
