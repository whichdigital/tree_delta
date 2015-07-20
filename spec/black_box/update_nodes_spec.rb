require 'spec_helper'

RSpec.describe TreeDelta do
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
        id: 'a',
        value: 9
      ),
      TreeDelta::Operation.new(
        type:  :update,
        id: 'b',
        value: 10
      ),
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
        id: 'c',
        value: 11
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
      )
    ]
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
        value: 9
      )
    ]
  end

  it 'can add and update a root node' do
    to = AsciiTree.parse('
             (    a{9}    )
             /     |      \
          (b{2})  h{8}  (c{3})
          /    \        /    \
         d{4}   e{5}   f{6}   g{7}
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
        value: 9
      )
    ]
  end
end
