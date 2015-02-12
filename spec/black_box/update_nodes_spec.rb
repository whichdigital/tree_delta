require 'spec_helper'

describe TreeDelta do
  let(:from) do
    AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{2})        (c{3})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
    ')
  end

  it 'can update a leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{2})        (c{3})
          /    \        /    \
         d{8}   e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type:  :update,
        id: 'd',
        value: 8
      )
    ]
  end

  it 'can update a non-leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{8})        (c{3})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type:  :update,
        id: 'b',
        value: 8
      )
    ]
  end

  it 'can update a root node' do
    to = AsciiTree.parse('
             (    a{8}    )
             /            \
          (b{2})        (c{3})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type:  :update,
        id: 'a',
        value: 8
      )
    ]
  end

  it 'can update all nodes' do
    to = AsciiTree.parse('
             (     a{9}     )
             /              \
          (b{10})         (c{11})
          /     \         /     \
         d{12}   e{13}   f{14}   g{15}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type:  :update,
        id: 'd',
        value: 12
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'e',
        value: 13
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'b',
        value: 10
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'f',
        value: 14
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'g',
        value: 15
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'c',
        value: 14
      )
    ]
    # actual output:
    #  <TreeDelta::Operation:0x007f8e811981d0 @type=:detach, @id="c">,
    #  <TreeDelta::Operation:0x007f8e81198400 @type=:detach, @id="b">,
    #  <TreeDelta::Operation:0x007f8e8119ae08 @type=:delete, @id="a{1}">,
    #  <TreeDelta::Operation:0x007f8e81183cf8 @type=:create, @id="a{9}", @position=0>,
    #  <TreeDelta::Operation:0x007f8e811830c8 @type=:attach, @id="b", @position=0, @parent="a{9}">,
    #  <TreeDelta::Operation:0x007f8e81182b78 @type=:attach, @id="c", @position=1, @parent="a{9}">,
    #  <TreeDelta::Operation:0x007f8e8116bd38 @type=:update, @id="b", @value=10>,
    #  <TreeDelta::Operation:0x007f8e811685e8 @type=:update, @id="d", @value=12>,
    #  <TreeDelta::Operation:0x007f8e81158440 @type=:update, @id="e", @value=13>,
    #  <TreeDelta::Operation:0x007f8e811532d8 @type=:update, @id="c", @value=11>,
    #  <TreeDelta::Operation:0x007f8e811527e8 @type=:update, @id="f", @value=14>,
    #  <TreeDelta::Operation:0x007f8e81152220 @type=:update, @id="g", @value=15>
  end

  it 'can move and update a leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{2})        (c{3})
          /    \        /    \
         f{6}   e{5}   d{8}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'd',
        value: 8
      )
    ]
  end

  it 'can move and update a non-leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (c{3})        (b{8})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'b',
        value: 8
      )
    ]
  end

  it 'can move and update a root node' do
    to = AsciiTree.parse('
             (    c{3}    )
             /            \
          (b{2})        (a{8})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'b'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'b',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'a',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'a',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'a',
        value: 8
      )
    ]
  end

  it 'can delete and update a leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{2})        (c{3})
          /    \             \
         d{4}   e{5}          g{8}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'g',
        value: 8
      )
    ]
  end

  it 'can delete and update a non-leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /
          (b{8})
          /    \
         d{4}   e{5}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'b',
        value: 8
      )
    ]
  end

  it 'can add and update a leaf node' do
    to = AsciiTree.parse('
             (    a{1}    )
             /            \
          (b{2})        (c{3})
          /    \        /    \
         d{4}   e{9}   f{6}   g{7}
        /
       h{8}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'd',
        position: 0,
        value: 8
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'e',
        value: 9
      )
    ]
  end

  it 'can add and update a non-leaf node' do
    to = AsciiTree.parse('
                (    a{1}    )
                /            \
          (   b{9}  )        (c{3})
          /    |    \        /    \
         d{4}  h{8}  e{5}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'b',
        position: 1,
        value: 8
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'b',
        value: '9'
      )
    ]
  # actual output:
  #  <TreeDelta::Operation:0x007fa90b1716a8 @type=:detach, @id="e">,
  #  <TreeDelta::Operation:0x007fa90b1717e8 @type=:detach, @id="d">,
  #  <TreeDelta::Operation:0x007fa90b172648 @type=:delete, @id="b">,
  #  <TreeDelta::Operation:0x007fa90b16b5f0 @type=:create, @id="b{9}", @parent="a{1}", @position=0>,
  #  <TreeDelta::Operation:0x007fa90b16b258 @type=:attach, @id="d", @parent="b{9}", @position=0>,
  #  <TreeDelta::Operation:0x007fa90b16b550 @type=:create, @id="h", @parent="b{9}", @position=1, @value=8>,
  #  <TreeDelta::Operation:0x007fa90b16b190 @type=:attach, @id="e", @parent="b{9}", @position=2>
  end

  it 'can add and update a root node' do
    to = AsciiTree.parse('
             (    a{9}    )
             /     |      \
          (b{2})  h{8}  (c{3})
          /    \        /    \
         d{4}   e{9}   f{6}   g{7}
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'a',
        position: 1,
        value: 8
      ),
      TreeDelta::Operation.new(
        type: :update,
        id: 'a',
        value: '9'
      )
    ]
    # actual output:
    #  <TreeDelta::Operation:0x007fce3396ffb0 @type=:detach, @id="c">,
    #  <TreeDelta::Operation:0x007fce3594c090 @type=:detach, @id="b">,
    #  <TreeDelta::Operation:0x007fce3594d120 @type=:delete, @id="a{1}">,
    #  <TreeDelta::Operation:0x007fce3396e0c0 @type=:create, @id="a{9}", @position=0>,
    #  <TreeDelta::Operation:0x007fce3396dcb0 @type=:attach, @id="b", @position=0, @parent="a{9}">,
    #  <TreeDelta::Operation:0x007fce3396dff8 @type=:create, @id="h", @position=1, @value=8, @parent="a{9}">,
    #  <TreeDelta::Operation:0x007fce3396dbe8 @type=:attach, @id="c", @position=2, @parent="a{9}">,
    #  <TreeDelta::Operation:0x007fce33967d38 @type=:update, @id="e", @value=9>
  end
end
