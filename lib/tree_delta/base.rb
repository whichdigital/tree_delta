class TreeDelta < Enumerator

  attr_reader :from, :to

  def initialize(from:, to:)
    @from, @to = from, to
  end

  def each(&block)
    deletes_and_detaches.each { |o| yield o }
    creates_and_attaches.each { |o| yield o }
    updates.each              { |o| yield o }
  end

  private

  def deletes_and_detaches
    traversal = Traversal.new(
      type:      :depth_first,
      direction: :right_to_left,
      order:     :post
    )

    enumerator = traversal.traverse(from)

    Sorter.sort(deletes.to_a + detaches.to_a, enumerator)
  end

  def creates_and_attaches
    traversal = Traversal.new(
      type:      :depth_first,
      direction: :left_to_right,
      order:     :pre
    )

    enumerator = traversal.traverse(to)

    Sorter.sort(creates.to_a + attaches.to_a, enumerator)
  end

  def creates
    intermediate.creates
  end

  def updates
    intermediate.updates
  end

  def deletes
    intermediate.deletes
  end

  def detaches
    intermediate.detaches
  end

  def attaches
    intermediate.attaches
  end

  def intermediate
    @intermediate ||= Intermediate.new(from: from, to: to)
  end

end
