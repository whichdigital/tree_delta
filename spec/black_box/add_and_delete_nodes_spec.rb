require 'spec_helper'

describe TreeDelta do
  let(:from) do
    AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
    ')
  end

  it 'can delete first and add a node to its sibling' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
            \     / \
             e   f   g
             |
             h
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'e',
        position: 0
      )
    ]

    #<TreeDelta::Operation:0x007f963aa17ca0 @type=:delete, @id="f", @parent="c", @position=0>,
    #<TreeDelta::Operation:0x007f963aa17a70 @type=:delete, @id="e", @parent="b", @position=1>,
    #<TreeDelta::Operation:0x007f963aa17890 @type=:delete, @id="d", @parent="b", @position=0>,
    #<TreeDelta::Operation:0x007f963aa17728 @type=:delete, @id="b", @parent="a", @position=0>,
    #<TreeDelta::Operation:0x007f963aa175e8 @type=:create, @id="h", @parent="g", @position=0>

    "#<AsciiTree::Node:0x007ff0299e3178 @id=\"a\", @value=nil, @parent=nil, @children=[
      #<AsciiTree::Node:0x007ff0299e2f70 @id=\"b\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e3178 ...>,
        @children=[#<AsciiTree::Node:0x007ff0299e2d18 @id=\"d\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e2f70 ...>,
          @children=[]>, #<AsciiTree::Node:0x007ff0299e28e0 @id=\"e\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e2f70 ...>,
          @children=[]>]>,
      #<AsciiTree::Node:0x007ff0299e2728 @id=\"c\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e3178 ...>,
        @children=[#<AsciiTree::Node:0x007ff0299e2548 @id=\"f\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e2728 ...>,
          @children=[]>, #<AsciiTree::Node:0x007ff0299e23e0 @id=\"g\", @value=nil, @parent=#<AsciiTree::Node:0x007ff0299e2728 ...>,
          @children=[]>]>]>"

    "#<AsciiTree::Node:0x007ff02a197040 @id=\"a\", @value=nil, @parent=nil, @children=[
      #<AsciiTree::Node:0x007ff02a193f30 @id=\"b\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a197040 ...>,
        @children=[#<AsciiTree::Node:0x007ff02a193e40 @id=\"e\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a193f30 ...>,
          @children=[#<AsciiTree::Node:0x007ff02a193d50 @id=\"h\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a193e40 ...>,
          @children=[]>]>]>,
      #<AsciiTree::Node:0x007ff02a193c38 @id=\"c\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a197040 ...>,
        @children=[#<AsciiTree::Node:0x007ff02a193b48 @id=\"f\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a193c38 ...>,
        @children=[]>,
      #<AsciiTree::Node:0x007ff02a193a30 @id=\"g\", @value=nil, @parent=#<AsciiTree::Node:0x007ff02a193c38 ...>,
        @children=[]>]>]>"

  end

  it 'can delete first non-leaf node, first leaf node of the 2nd non-leaf node and add a node to the last leaf node' do
    to = AsciiTree.parse('
            (  a  )
                  \
                   c
                    \
                     g
                     |
                     h
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'e',
        parent: 'b',
        position: 1,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'g',
        position: 0,
      )
    ]
  end

  it 'can delete a non-leaf node and a add a leaf node to the root as middle child' do
    to = AsciiTree.parse('
            (  a  )
               |  \
               h   c
                  / \
                 f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 1,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'a',
        position: 0
      )
    ]
  end
end