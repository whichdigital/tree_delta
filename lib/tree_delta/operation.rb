class TreeDelta::Operation

  attr_reader :type, :id, :value, :parent, :position

  def initialize(type:, id:, value: nil, parent: nil, position: nil)
    @type     = type
    @id       = id
    @value    = value    if value
    @parent   = parent   if parent
    @position = position if position
  end

  def ==(other)
    @type       == other.type   &&
      @id       == other.id     &&
      @value    == other.value  &&
      @parent   == other.parent &&
      @position == other.position
  end

end
