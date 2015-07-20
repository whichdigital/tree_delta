class TreeDelta::Operation

  attr_reader :type, :identity, :value, :parent, :position

  def initialize(type:, identity:, value: nil, parent: nil, position: nil)
    @type     = type
    @identity = identity
    @value    = value    if value
    @parent   = parent   if parent
    @position = position if position
  end

  def ==(other)
    @type       == other.type     &&
      @identity == other.identity &&
      @value    == other.value    &&
      @parent   == other.parent   &&
      @position == other.position
  end

end
